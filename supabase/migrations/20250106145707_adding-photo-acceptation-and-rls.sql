drop policy "Enable insert for users based on uploaded_by or profile_id" on "public"."photos";

create policy "Allow delete to own or allowed user"
on "public"."photos"
as permissive
for delete
to authenticated
using (((( SELECT auth.uid() AS uid) = profile_id) OR (( SELECT auth.uid() AS uid) = uploaded_by) OR is_user_allow_profile(auth.uid(), profile_id)));


create policy "Allow update to own or allowed user"
on "public"."photos"
as permissive
for update
to authenticated
using (((( SELECT auth.uid() AS uid) = profile_id) OR (( SELECT auth.uid() AS uid) = uploaded_by) OR is_user_allow_profile(auth.uid(), profile_id)));


create policy "Enable insert for users based on uploaded_by or profile_id"
on "public"."photos"
as permissive
for insert
to authenticated
with check (((( SELECT auth.uid() AS uid) = profile_id) OR (( SELECT auth.uid() AS uid) = uploaded_by) OR is_user_allow_profile(auth.uid(), profile_id)));



