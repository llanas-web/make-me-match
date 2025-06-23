drop policy "Allow update to own user" on "public"."profiles";

drop policy "Enable insert for users based on id" on "public"."profiles";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$declare is_admin boolean;
begin
  insert into public.users (id, email, username)
  values (new.id, new.email, split_part(new.email, '@', 1));

  IF NEW.raw_user_meta_data ? 'invited_by' THEN
    -- Insert a new row into public.profile_access
    INSERT INTO public.profile_access (profile_id, user_id)
    VALUES (
      (NEW.raw_user_meta_data->>'invited_by')::uuid, -- profile_id (inviter's ID)
      NEW.id                                -- user_id (new user's ID)
    );
  END IF;

  return new;

end;$function$
;


grant trigger on table "auth"."users" to "dashboard_user";

CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION handle_new_user();
