drop policy "Allow select own or allowed selected_photos " on "public"."selected_photos";

drop function if exists "public"."get_top_photos"();

drop function if exists "public"."get_top_photos_by_profile"(profile_id uuid);

create or replace view "public"."top_photos_by_profile" as  WITH photo_scores AS (
         SELECT spp.profile_id,
            spp.photo_id,
            sum((1.0 / (spp."order")::numeric)) AS score
           FROM selected_photos_profile spp
          WHERE (spp."order" > 0)
          GROUP BY spp.profile_id, spp.photo_id
        ), ranked_photos AS (
         SELECT ps.profile_id,
            ps.photo_id,
            ps.score,
            (rank() OVER (PARTITION BY ps.profile_id ORDER BY ps.score DESC))::integer AS rank
           FROM photo_scores ps
        )
 SELECT rp.profile_id,
    rp.photo_id,
    rp.score,
    rp.rank
   FROM ranked_photos rp
  WHERE (rp.rank <= 6);


create policy "Allow select own or allowed selected_photos "
on "public"."selected_photos"
as permissive
for select
to authenticated
using (((auth.uid() = user_id) OR (EXISTS ( SELECT 1
   FROM photos
  WHERE ((photos.id = selected_photos.photo_id) AND (photos.profile_id = auth.uid()))))));



