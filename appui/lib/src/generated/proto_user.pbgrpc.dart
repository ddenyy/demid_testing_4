//
//  Generated code. Do not modify.
//  source: proto_user.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'proto_user.pb.dart' as $0;

export 'proto_user.pb.dart';

@$pb.GrpcServiceName('UserService')
class UserServiceClient extends $grpc.Client {
  static final _$registration = $grpc.ClientMethod<$0.RegistrationRequest, $0.UserResponse>(
      '/UserService/Registration',
      ($0.RegistrationRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.UserResponse.fromBuffer(value));
  static final _$login = $grpc.ClientMethod<$0.LoginRequest, $0.UserResponse>(
      '/UserService/Login',
      ($0.LoginRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.UserResponse.fromBuffer(value));

  UserServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.UserResponse> registration($0.RegistrationRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$registration, request, options: options);
  }

  $grpc.ResponseFuture<$0.UserResponse> login($0.LoginRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$login, request, options: options);
  }
}

@$pb.GrpcServiceName('UserService')
abstract class UserServiceBase extends $grpc.Service {
  $core.String get $name => 'UserService';

  UserServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.RegistrationRequest, $0.UserResponse>(
        'Registration',
        registration_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.RegistrationRequest.fromBuffer(value),
        ($0.UserResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LoginRequest, $0.UserResponse>(
        'Login',
        login_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LoginRequest.fromBuffer(value),
        ($0.UserResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.UserResponse> registration_Pre($grpc.ServiceCall $call, $async.Future<$0.RegistrationRequest> $request) async {
    return registration($call, await $request);
  }

  $async.Future<$0.UserResponse> login_Pre($grpc.ServiceCall $call, $async.Future<$0.LoginRequest> $request) async {
    return login($call, await $request);
  }

  $async.Future<$0.UserResponse> registration($grpc.ServiceCall call, $0.RegistrationRequest request);
  $async.Future<$0.UserResponse> login($grpc.ServiceCall call, $0.LoginRequest request);
}
