drop policy "Allow select to own profile or is allowed one" on "public"."sub_profile";

create policy "Allow select to own profile or is allowed one"
on "public"."sub_profile"
as permissive
for select
to authenticated
using (((auth.uid() = profile_id) OR is_auth_user_allowed_profile(profile_id)));



