alter table "public"."profiles" drop column "description";

alter table "public"."profiles" drop column "ordered_photos";

alter table "public"."sub_profile" add column "bio" text default ''::text;

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.is_auth_user_allowed_profile(_profile_id uuid)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$BEGIN
  RETURN EXISTS(
    SELECT 1 
    FROM public.profile_access 
    WHERE (
      profile_access.user_id = auth.uid() 
      AND profile_access.profile_id = _profile_id
    )
  );
END;$function$
;


