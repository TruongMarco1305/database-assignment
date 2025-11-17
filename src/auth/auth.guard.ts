// import { EntityManager, ref } from '@mikro-orm/postgresql';
// import {
//   CanActivate,
//   ExecutionContext,
//   Injectable,
//   UnauthorizedException,
// } from '@nestjs/common';
// import { Reflector } from '@nestjs/core';
// import { Request } from 'express';
// import { CustomDecoratorKey } from 'src/common/custom-decorator-keys';

// import { Role } from '../decorators';
// import { Token } from '../entities';
// import { TokenService } from '../services';
// import { UserRole } from '@/users/types';
// import { UserService } from 'src/user/user.service';

// /**
//  * Provides authentication for routes that it is applied to.
//  * Requests must provide a valid Bearer token in the Authorization header.
//  * By default, applying this guard to a route will block the request if
//  * the user is not authenticated. To bypass this (only authenticate if possible),
//  * declare a route with `@BlockIfUnauthorized(false)`.
//  */
// @Injectable()
// export class AuthGuard implements CanActivate {
//   constructor(
//     private tokenService: TokenService,
//     private userService: UserService,
//     private reflector: Reflector,
//   ) {}

//   async canActivate(context: ExecutionContext): Promise<boolean> {
//     try {
//       const request: Request = context.switchToHttp().getRequest();

//       const bearerToken = this.extractBearerToken(request);

//       const { userId, expiredAt } = await this.tokenService.readAccessToken(bearerToken);

//       const user = this.userService.findById(userId);

//       /**
//        * If roles are specified for route, authorize based on it.
//        * Only users with at least one specified roles are allowed.
//        * Only exception to this is the `ADMIN` role, which bypasses all checks.
//        */
//       const roles = this.reflector.get(Role, context.getHandler());

//       // eslint-disable-next-line @typescript-eslint/no-unnecessary-condition
//       if (roles && user.role !== UserRole.ADMIN && !roles.includes(user.role)) {
//         const requiredRoles = roles.includes(UserRole.ADMIN)
//           ? roles
//           : [UserRole.ADMIN, ...roles];

//         throw new UnauthorizedException(
//           `User does not have the required roles: ${requiredRoles.join(', ')}. Current permission: ${user.role}`,
//         );
//       }

//       request.user = {
//         token,
//         profile: user,
//       };
//     } catch (error) {
//       const shouldBlock = this.getShouldBlockIfUnauthorized(context);

//       if (shouldBlock) {
//         throw new UnauthorizedException();
//       }
//     }

//     return true;
//   }

//   private extractBearerToken(request: Request): string {
//     const [type, token] = request.headers.authorization?.split(' ') ?? [];

//     if (type !== 'Bearer') {
//       throw new UnauthorizedException();
//     }

//     return token;
//   }
// }
