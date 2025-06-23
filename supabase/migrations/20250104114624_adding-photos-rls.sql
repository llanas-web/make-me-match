create policy "Enable insert for users based on uploaded_by or profile_id"
on "public"."photos"
as permissive
for insert
to public
with check (((( SELECT auth.uid() AS uid) = profile_id) OR (( SELECT auth.uid() AS uid) = uploaded_by)));


create policy "Enable users to view their own data only"
on "public"."photos"
as permissive
for select
to authenticated
using (((( SELECT auth.uid() AS uid) = profile_id) OR (( SELECT auth.uid() AS uid) = uploaded_by)));



