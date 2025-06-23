drop policy "Allow insert for own profile or user_id" on "public"."sub_profile";

drop policy "Allow select to own profile or is allowed one" on "public"."sub_profile";

drop policy "Allow update for own profile or user_id" on "public"."sub_profile";

revoke delete on table "public"."sub_profile" from "anon";

revoke insert on table "public"."sub_profile" from "anon";

revoke references on table "public"."sub_profile" from "anon";

revoke select on table "public"."sub_profile" from "anon";

revoke trigger on table "public"."sub_profile" from "anon";

revoke truncate on table "public"."sub_profile" from "anon";

revoke update on table "public"."sub_profile" from "anon";

revoke delete on table "public"."sub_profile" from "authenticated";

revoke insert on table "public"."sub_profile" from "authenticated";

revoke references on table "public"."sub_profile" from "authenticated";

revoke select on table "public"."sub_profile" from "authenticated";

revoke trigger on table "public"."sub_profile" from "authenticated";

revoke truncate on table "public"."sub_profile" from "authenticated";

revoke update on table "public"."sub_profile" from "authenticated";

revoke delete on table "public"."sub_profile" from "service_role";

revoke insert on table "public"."sub_profile" from "service_role";

revoke references on table "public"."sub_profile" from "service_role";

revoke select on table "public"."sub_profile" from "service_role";

revoke trigger on table "public"."sub_profile" from "service_role";

revoke truncate on table "public"."sub_profile" from "service_role";

revoke update on table "public"."sub_profile" from "service_role";

alter table "public"."sub_profile" drop constraint "sub_profile_profile_id_fkey";

alter table "public"."sub_profile" drop constraint "sub_profile_user_id_fkey";

alter table "public"."sub_profile" drop constraint "sub_profile_pkey";

drop index if exists "public"."sub_profile_pkey";

drop table "public"."sub_profile";

create table "public"."selected_photos" (
    "user_id" uuid not null default gen_random_uuid(),
    "photo_id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now(),
    "order" smallint not null default '0'::smallint
);


alter table "public"."selected_photos" enable row level security;

CREATE UNIQUE INDEX selected_photos_pkey ON public.selected_photos USING btree (user_id, photo_id);

alter table "public"."selected_photos" add constraint "selected_photos_pkey" PRIMARY KEY using index "selected_photos_pkey";

alter table "public"."selected_photos" add constraint "selected_photos_photo_id_fkey" FOREIGN KEY (photo_id) REFERENCES photos(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."selected_photos" validate constraint "selected_photos_photo_id_fkey";

alter table "public"."selected_photos" add constraint "selected_photos_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."selected_photos" validate constraint "selected_photos_user_id_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.handle_new_profile()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$declare is_admin boolean;
begin
  insert into public.sub_profile (profile_id, user_id)
  values (new.id, new.id);

  return new;

end;$function$
;

create or replace view "public"."selected_photos_profile" as  SELECT selected_photos.photo_id,
    selected_photos.user_id,
    photos.profile_id
   FROM (selected_photos
     LEFT JOIN photos ON ((selected_photos.photo_id = photos.id)));


CREATE OR REPLACE FUNCTION public.update_photo_order(ordered_photos jsonb)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    photo_uuid TEXT;
    photo_index INTEGER;
BEGIN
    -- Iterate through the JSONB array using array indexes
    FOR photo_index IN 0 .. (jsonb_array_length(ordered_photos->'ordered_photos') - 1) LOOP
        -- Extract the photo UUID from the array
        photo_uuid := (ordered_photos->'ordered_photos')->>photo_index;

        -- Update the `order` column for the corresponding photo ID
        UPDATE selected_photos
        SET "order" = photo_index + 1  -- Adding 1 to make the order 1-based instead of 0-based
        WHERE selected_photos.photo_id = photo_uuid AND selected_photos.user_id = auth.uid();
    END LOOP;
END;
$function$
;

grant delete on table "public"."selected_photos" to "anon";

grant insert on table "public"."selected_photos" to "anon";

grant references on table "public"."selected_photos" to "anon";

grant select on table "public"."selected_photos" to "anon";

grant trigger on table "public"."selected_photos" to "anon";

grant truncate on table "public"."selected_photos" to "anon";

grant update on table "public"."selected_photos" to "anon";

grant delete on table "public"."selected_photos" to "authenticated";

grant insert on table "public"."selected_photos" to "authenticated";

grant references on table "public"."selected_photos" to "authenticated";

grant select on table "public"."selected_photos" to "authenticated";

grant trigger on table "public"."selected_photos" to "authenticated";

grant truncate on table "public"."selected_photos" to "authenticated";

grant update on table "public"."selected_photos" to "authenticated";

grant delete on table "public"."selected_photos" to "service_role";

grant insert on table "public"."selected_photos" to "service_role";

grant references on table "public"."selected_photos" to "service_role";

grant select on table "public"."selected_photos" to "service_role";

grant trigger on table "public"."selected_photos" to "service_role";

grant truncate on table "public"."selected_photos" to "service_role";

grant update on table "public"."selected_photos" to "service_role";

create policy "Allow delete for allowed user"
on "public"."selected_photos"
as permissive
for select
to public
using ((auth.uid() = user_id));


create policy "Allow insert for allowed user"
on "public"."selected_photos"
as permissive
for insert
to authenticated
with check (((EXISTS ( SELECT 1
   FROM photos
  WHERE ((photos.id = selected_photos.photo_id) AND (photos.profile_id = auth.uid())))) OR is_auth_user_allowed_profile(( SELECT photos.profile_id
   FROM photos
  WHERE (photos.id = selected_photos.photo_id)))));


create policy "Allow select own or allowed selected_photos "
on "public"."selected_photos"
as permissive
for select
to authenticated
using (((auth.uid() = user_id) OR is_auth_user_allowed_profile(( SELECT photos.profile_id
   FROM photos
  WHERE (photos.id = selected_photos.photo_id)))));


create policy "Allow update for allowed user"
on "public"."selected_photos"
as permissive
for update
to authenticated
using ((auth.uid() = user_id));


CREATE TRIGGER on_new_profile AFTER INSERT ON public.profiles FOR EACH STATEMENT EXECUTE FUNCTION handle_new_profile();


