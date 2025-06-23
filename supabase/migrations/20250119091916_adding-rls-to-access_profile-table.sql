create policy "Allow insert for allowed own profile"
on "public"."profile_access"
as permissive
for insert
to authenticated
with check ((profile_id = auth.uid()));



