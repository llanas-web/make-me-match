create policy "Allow delete for own or allowed user"
on "public"."photo_reactions"
as permissive
for delete
to authenticated
using ((auth.uid() = user_id));


create policy "Allow insert for allowed user"
on "public"."photo_reactions"
as permissive
for insert
to authenticated
with check (((EXISTS ( SELECT 1
   FROM photos
  WHERE ((photos.id = photo_reactions.photo_id) AND (photos.profile_id = auth.uid())))) OR is_auth_user_allowed_profile(( SELECT photos.profile_id
   FROM photos
  WHERE (photos.id = photo_reactions.photo_id)))));


create policy "Allow select for own or allowed user"
on "public"."photo_reactions"
as permissive
for select
to authenticated
using (((auth.uid() = user_id) OR is_auth_user_allowed_profile(( SELECT photos.profile_id
   FROM photos
  WHERE (photos.id = photo_reactions.photo_id)))));


create policy "Allow update to own reactions"
on "public"."photo_reactions"
as permissive
for update
to authenticated
using ((auth.uid() = user_id));



