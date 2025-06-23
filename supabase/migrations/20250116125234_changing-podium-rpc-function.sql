set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.get_top_photos()
 RETURNS TABLE(photo_id uuid, score numeric, rank integer)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    WITH photo_scores AS (
        SELECT
            photo_id,
            SUM(1.0 / "order") AS score -- Inverse rank, higher rank contributes more
        FROM
            selected_photos_profile
        WHERE
            "order" > 0 -- Ensure valid orders
        GROUP BY
            photo_id
    ),
    ranked_photos AS (
        SELECT
            photo_id,
            score,
            RANK() OVER (ORDER BY score DESC) AS rank
        FROM
            photo_scores
    )
    SELECT
        photo_id,
        score,
        rank
    FROM
        ranked_photos
    WHERE
        rank <= 3; -- Top 3
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_top_photos_by_profile(profile_id uuid)
 RETURNS TABLE(photo_id uuid, score numeric, rank integer)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    WITH photo_scores AS (
        SELECT
            spp.photo_id,  -- Explicitly reference the photo_id from selected_photos_profile (spp alias)
            SUM(1.0 / spp."order") AS score -- Inverse rank, higher rank contributes more
        FROM
            selected_photos_profile spp  -- Alias for selected_photos_profile
        WHERE
            spp."order" > 0 -- Ensure valid orders
            AND spp.profile_id = $1 -- Filter by the provided profile_id
        GROUP BY
            spp.photo_id -- Use alias here as well
    ),
    ranked_photos AS (
        SELECT
            ps.photo_id,  -- Explicitly reference the photo_id from photo_scores (ps alias)
            ps.score,
            RANK() OVER (ORDER BY ps.score DESC) :: integer AS rank  -- Cast rank to integer
        FROM
            photo_scores ps  -- Alias for photo_scores CTE
    )
    SELECT
        rp.photo_id,  -- Explicitly reference photo_id from ranked_photos (rp alias)
        rp.score,
        rp.rank
    FROM
        ranked_photos rp  -- Alias for ranked_photos CTE
    WHERE
        rp.rank <= 9; -- Top 3
END;
$function$
;

CREATE OR REPLACE FUNCTION public.is_auth_user_allowed_profile(_profile_id uuid)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
  RETURN EXISTS(
    SELECT 1
    FROM public.profile_access
    WHERE (
      profile_access.user_id = auth.uid()
      AND profile_access.profile_id = _profile_id
    )
  );
END;
$function$
;


