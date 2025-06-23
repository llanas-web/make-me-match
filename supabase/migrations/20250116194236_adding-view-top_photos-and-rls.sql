drop policy "Allow select own or allowed selected_photos " on "public"."selected_photos";

create policy "Allow select own or allowed selected_photos "
on "public"."selected_photos"
as permissive
for select
to authenticated
using (((auth.uid() = user_id) OR (EXISTS ( SELECT 1
   FROM photos
  WHERE ((photos.id = selected_photos.photo_id) AND (photos.profile_id = auth.uid())))) OR is_auth_user_allowed_profile(( SELECT photos.profile_id
   FROM photos
  WHERE (photos.id = selected_photos.photo_id)))));



