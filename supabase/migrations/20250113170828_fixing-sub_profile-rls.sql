drop policy "Allow insert for own profile or user_id" on "public"."sub_profile";

create policy "Allow insert for own profile or user_id"
on "public"."sub_profile"
as permissive
for insert
to authenticated
with check (((auth.uid() = profile_id) OR is_auth_user_allowed_profile(profile_id)));



