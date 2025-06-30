import { Injectable } from '@nestjs/common';

@Injectable()
export class LocationService {
}

/*
import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { Location } from '@prisma/client';

@Injectable()
export class LocationService {
  constructor(private prisma: PrismaService) {}

  create(data: { userId: string; latitude: number; longitude: number }): Promise<Location> {
    return this.prisma.location.create({
      data: {
        ...data,
      },
    });
  }

  findAll(): Promise<Location[]> {
    return this.prisma.location.findMany({
      orderBy: {
        timestamp: 'desc',
      },
    });
  }

  findLatestByUser(userId: string): Promise<Location | null> {
    return this.prisma.location.findFirst({
      where: { userId },
      orderBy: { timestamp: 'desc' },
    });
  }
}
*/