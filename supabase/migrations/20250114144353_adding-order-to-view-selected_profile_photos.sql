drop view if exists "public"."selected_photos_profile";

create or replace view "public"."selected_photos_profile" as  SELECT selected_photos.photo_id,
    selected_photos.user_id,
    selected_photos."order",
    photos.profile_id
   FROM (selected_photos
     LEFT JOIN photos ON ((selected_photos.photo_id = photos.id)));



