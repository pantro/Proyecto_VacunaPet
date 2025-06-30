// src/location/dto/create-location.input.ts
import { InputType, Field } from '@nestjs/graphql';

@InputType()
export class CreateLocationInput {
  @Field()
  userId: string;

  @Field()
  latitude: number;

  @Field()
  longitude: number;
}
