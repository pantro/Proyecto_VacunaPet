import { Module } from '@nestjs/common';
import { GraphQLModule } from '@nestjs/graphql';
import { ApolloDriver, ApolloDriverConfig } from '@nestjs/apollo'; 
import { join } from 'path';

import { LocationModule } from './location/location.module';
import { PrismaModule } from './prisma/prisma.module';

@Module({
  imports: [
    GraphQLModule.forRoot<ApolloDriverConfig>({
      driver: ApolloDriver, // <-- ✅ REQUERIDO DESDE v10
      autoSchemaFile: join(process.cwd(), 'src/schema.gql'),
      playground: true, // opcional, útil en desarrollo
      installSubscriptionHandlers: true, // opcional en v10, útil si usas subscriptions por WebSocket
      subscriptions: {
        'graphql-ws': true,   // activa graphql-ws (versión moderna)
        'subscriptions-transport-ws': true,
      },
    }),
    PrismaModule,
    LocationModule,
  ],
})
export class AppModule {}
