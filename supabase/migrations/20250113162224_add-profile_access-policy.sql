create policy "Allow select for own profile or user_id"
on "public"."profile_access"
as permissive
for select
to authenticated
using (((auth.uid() = profile_id) OR (auth.uid() = user_id)));



