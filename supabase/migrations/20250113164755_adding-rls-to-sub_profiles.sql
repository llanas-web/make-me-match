create policy "Allow insert for own profile or user_id"
on "public"."sub_profile"
as permissive
for insert
to authenticated
with check (((auth.uid() = profile_id) OR (auth.uid() = user_id)));


create policy "Allow select to own profile or is allowed one"
on "public"."sub_profile"
as permissive
for select
to authenticated
using (((auth.uid() = user_id) OR is_auth_user_allowed_profile(profile_id)));


create policy "Allow update for own profile or user_id"
on "public"."sub_profile"
as permissive
for update
to authenticated
using (((auth.uid() = profile_id) OR (auth.uid() = user_id)));



