drop policy "Enable insert for users based on uploaded_by or profile_id" on "public"."photos";

create policy "Enable insert for users based on uploaded_by or profile_id"
on "public"."photos"
as permissive
for insert
to public
with check (((( SELECT auth.uid() AS uid) = profile_id) OR (( SELECT auth.uid() AS uid) = uploaded_by) OR is_user_allow_profile(auth.uid(), profile_id)));



