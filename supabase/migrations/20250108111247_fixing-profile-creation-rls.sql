alter table "public"."profiles" drop column "metadata";

create policy "Allow update to own user"
on "public"."profiles"
as permissive
for update
to authenticated
using ((( SELECT auth.uid() AS uid) = id));



