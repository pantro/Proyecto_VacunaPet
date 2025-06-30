import { Resolver, Mutation, Args, Subscription, Query } from '@nestjs/graphql';
import { Location } from './location.model';
import { pubSub } from 'src/pubsub';
import { CreateLocationInput } from './dto/create-location.input';

@Resolver(() => Location)
export class LocationResolver {
  // 🔥 Se elimina el constructor porque ya no usamos LocationService

  @Query(() => String)
  ping(): string {
    return 'pong';
  }
  
  @Mutation(() => Location)
  async createLocation(@Args('input') input: CreateLocationInput): Promise<Location> {
    const newLocation: Location = {
      id: input.userId,
      userId: input.userId,
      latitude: input.latitude,
      longitude: input.longitude,
      timestamp: new Date(),
    };

    console.log('📡 Publicando ubicación para', input.userId);

    await pubSub.publish('locationUpdated', {
      locationUpdated: newLocation,
    });

    return newLocation;
  }

  @Subscription(() => Location)
  locationUpdated() {
    console.log('🧲 Cliente suscrito a actualizaciones de ubicación');
    return pubSub.asyncIterator('locationUpdated');
  }

  // 🔥 Se elimina el query 'locations' y 'latestLocationByUser' porque usaban la base de datos
}


/*
import { Resolver, Query, Mutation, Args, Subscription } from '@nestjs/graphql';
import { LocationService } from './location.service';
import { Location } from './location.model';
import { pubSub } from 'src/pubsub';
import { CreateLocationInput } from './dto/create-location.input';

@Resolver(() => Location)
export class LocationResolver {
  constructor(private locationService: LocationService) {}

  @Query(() => [Location])
  locations() {
    return this.locationService.findAll();
  }

  @Mutation(() => Location) async createLocation(
    @Args('input') input: CreateLocationInput,
  ) {
    const newLocation = await this.locationService.create(input);

    console.log('📡 Publicando ubicación para', input.userId);

    await pubSub.publish('locationUpdated', {
      locationUpdated: newLocation,
    });

    return newLocation;
  }

  @Subscription(() => Location, {
  })
  locationUpdated() {
    console.log('🧲 Cliente suscrito');
    return pubSub.asyncIterator('locationUpdated');
  }

  @Query(() => Location, { nullable: true })
  latestLocationByUser(@Args('userId') userId: string) {
    return this.locationService.findLatestByUser(userId);
  }
}
*/