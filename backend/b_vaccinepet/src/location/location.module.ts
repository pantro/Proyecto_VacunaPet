import { Module } from '@nestjs/common';
import { LocationResolver } from './location.resolver';
import { LocationService } from './location.service';
/* bd inactiva*///import { PrismaModule } from '../prisma/prisma.module';

@Module({
  /* bd inactiva*///imports: [PrismaModule],
  providers: [LocationResolver, LocationService],
})
export class LocationModule {}
