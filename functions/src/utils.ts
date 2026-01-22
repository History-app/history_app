import * as functions from "firebase-functions/v1";

export const baseFunction = functions.region("asia-northeast1");

export type Result<T, E> = Success<T, E> | Failure<T, E>;

export class Success<T, E> {
  constructor(readonly value: T) {}
  type = "success" as const;
  isSuccess(): this is Success<T, E> {
    return true;
  }

  isFailure(): this is Failure<T, E> {
    return false;
  }
}

export class Failure<T, E> {
  constructor(readonly value: E) {}
  type = "failure" as const;
  isSuccess(): this is Success<T, E> {
    return false;
  }

  isFailure(): this is Failure<T, E> {
    return true;
  }
}

export class HttpError extends Error {
  code?: number;
}
