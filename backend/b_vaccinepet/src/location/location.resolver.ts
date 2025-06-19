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
    const location = await this.locationService.create({ userId, latitude, longitude });
    pubSub.publish('locationUpdated', { locationUpdated: location });
    return location;
  }

  @Subscription(() => Location, {
    filter: (payload, variables) => payload.locationUpdated.userId === variables.userId,
  })
  locationUpdated(@Args('userId') userId: string) {
    return pubSub.asyncIterator('locationUpdated');
  }

  @Query(() => Location, { nullable: true })
  latestLocationByUser(@Args('userId') userId: string) {
    return this.locationService.findLatestByUser(userId);
  }
}
