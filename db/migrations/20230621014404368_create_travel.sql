-- +micrate Up
CREATE TABLE travels (
  id BIGSERIAL PRIMARY KEY,
  travel_stops INT[]
);


-- +micrate Down
DROP TABLE IF EXISTS travels;
