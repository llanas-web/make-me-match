drop policy "Allow delete for allowed user" on "public"."selected_photos";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.handle_delete_selected_photos()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$BEGIN
    RAISE LOG 'Deleting photo_id: %, user_id: %', OLD.photo_id, OLD.user_id;
    -- Reorder the photos for the user after the deletion of a photo
    UPDATE selected_photos
    SET "order" = sub.new_order
    FROM (
        SELECT photo_id, user_id, ROW_NUMBER() OVER (ORDER BY "order") AS new_order
        FROM selected_photos
        WHERE user_id = OLD.user_id
    ) AS sub
    WHERE selected_photos.photo_id = sub.photo_id
    AND selected_photos.user_id = sub.user_id;

    RAISE LOG 'Reordered photos for user_id: %', OLD.user_id;
    -- Return NULL to finalize the delete action
    RETURN NULL;
END;$function$
;

CREATE OR REPLACE FUNCTION public.handle_new_selected_photos()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$BEGIN
-- Check if `order` is NULL or not provided
    -- Check if the user already has 9 selected photos
    IF (SELECT COUNT(*) FROM selected_photos WHERE user_id = NEW.user_id) >= 9 THEN
        RAISE EXCEPTION 'Cannot select more than 9 photos for user %', NEW.user_id;
    END IF;

    NEW."order" := COALESCE((SELECT MAX("order") FROM selected_photos WHERE selected_photos.user_id = NEW.user_id), 0) + 1;
  RETURN NEW;
END;$function$
;

CREATE OR REPLACE FUNCTION public.update_photo_order(ordered_photos jsonb)
 RETURNS void
 LANGUAGE plpgsql
AS $function$DECLARE
    photo_uuid uuid;
    idx uuid;
    ordered_photos_length INT;
BEGIN
    -- Check if the 'ordered_photos' array exists and is not null
    IF ordered_photos->'ordered_photos' IS NOT NULL THEN
        ordered_photos_length := jsonb_array_length(ordered_photos->'ordered_photos');
        
        -- Loop through the ordered_photos array and update the "order" column
        FOR idx IN 0..ordered_photos_length - 1 LOOP
            photo_uuid := (ordered_photos->'ordered_photos'->>idx)::uuid;

            UPDATE selected_photos
            SET "order" = idx + 1
            WHERE selected_photos.photo_id = photo_uuid AND user_id = auth.uid();
        END LOOP;
    ELSE
        RAISE EXCEPTION 'ordered_photos array is missing or null in the provided jsonb';
    END IF;

    -- Optionally, you can add a RETURN statement here if needed
    RETURN;
END;$function$
;

create policy "Allow delete for allowed user"
on "public"."selected_photos"
as permissive
for delete
to authenticated
using ((auth.uid() = user_id));


CREATE TRIGGER on_delete_selected_photos AFTER DELETE ON public.selected_photos FOR EACH ROW EXECUTE FUNCTION handle_delete_selected_photos();

CREATE TRIGGER on_new_selected_photos BEFORE INSERT ON public.selected_photos FOR EACH ROW EXECUTE FUNCTION handle_new_selected_photos();


