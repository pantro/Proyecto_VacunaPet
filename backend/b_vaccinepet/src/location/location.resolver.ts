import { Resolver, Query, Mutation, Args, Subscription } from '@nestjs/graphql';
import { LocationService } from './location.service';
import { Location } from './location.model';
import { pubSub } from 'src/pubsub';

@Resolver(() => Location)
export class LocationResolver {
  constructor(private locationService: LocationService) {}

  @Query(() => [Location])
  locations() {
    return this.locationService.findAll();
  }

  @Mutation(() => Location)
  async createLocation(
    @Args('userId') userId: string,
    @Args('latitude') latitude: number,
    @Args('longitude') longitude: number,
  ) {
    const newLocation = await this.locationService.create({
      userId,
      latitude,
      longitude,
    });
  
    console.log('📡 Publicando ubicación para', userId);
  
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
