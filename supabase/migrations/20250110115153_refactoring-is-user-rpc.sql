drop policy if exists "Allow delete to own or allowed user" on "public"."photos";

drop policy if exists "Allow update to own or allowed user" on "public"."photos";

drop policy if exists "Enable insert for users based on uploaded_by or profile_id" on "public"."photos";

drop policy if exists "Enable users to view their own data only" on "public"."photos";

drop policy if exists "Enable users to view their own data or their accessible data" on "public"."profiles";

drop policy if exists "Enable user to view their own data" on "public"."users";


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

create policy "Allow delete to own or allowed user"
on "public"."photos"
as permissive
for delete
to authenticated
using (((( SELECT auth.uid() AS uid) = profile_id) OR (( SELECT auth.uid() AS uid) = uploaded_by) OR is_auth_user_allowed_profile(profile_id)));


create policy "Allow update to own or allowed user"
on "public"."photos"
as permissive
for update
to authenticated
using (((( SELECT auth.uid() AS uid) = profile_id) OR (( SELECT auth.uid() AS uid) = uploaded_by) OR is_auth_user_allowed_profile(profile_id)));


create policy "Enable insert for users based on uploaded_by or profile_id"
on "public"."photos"
as permissive
for insert
to authenticated
with check (((( SELECT auth.uid() AS uid) = profile_id) OR (( SELECT auth.uid() AS uid) = uploaded_by) OR is_auth_user_allowed_profile(profile_id)));


create policy "Enable users to view their own data only"
on "public"."photos"
as permissive
for select
to authenticated
using (((( SELECT auth.uid() AS uid) = profile_id) OR (( SELECT auth.uid() AS uid) = uploaded_by) OR (is_auth_user_allowed_profile(profile_id) AND (status = 'accepted'::photos_status))));


create policy "Enable users to view their own data or their accessible data"
on "public"."profiles"
as permissive
for select
to authenticated
using (((id = auth.uid()) OR is_auth_user_allowed_profile(id)));


create policy "Enable user to view their own data"
on "public"."users"
as permissive
for select
to authenticated
using (((auth.uid() = id) OR is_auth_user_allowed_profile(id) OR (EXISTS ( SELECT 1
   FROM profile_access
  WHERE ((profile_access.user_id = users.id) AND (profile_access.profile_id = auth.uid()))))));



drop policy if exists"Give users access to own or allowed folder" on "storage"."objects";

drop policy if exists "Give users insert access to own or allowed folder" on "storage"."objects";

create policy "Give users access to own or allowed folder"
on "storage"."objects"
as permissive
for select
to authenticated
using (((bucket_id = 'profile_photos'::text) AND ((auth.uid() = ((storage.foldername(name))[1])::uuid) OR (auth.uid() = (owner_id)::uuid) OR is_auth_user_allowed_profile(((storage.foldername(name))[1])::uuid))));


create policy "Give users insert access to own or allowed folder"
on "storage"."objects"
as permissive
for insert
to authenticated
with check ((((bucket_id = 'profile_photos'::text) AND (auth.uid() = ((storage.foldername(name))[1])::uuid)) OR is_auth_user_allowed_profile(((storage.foldername(name))[1])::uuid)));




drop function if exists "public"."is_user_allow_profile"(_user_id uuid, _profile_id uuid);