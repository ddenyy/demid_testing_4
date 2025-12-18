//
//  Generated code. Do not modify.
//  source: components.proto
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

import 'components.pb.dart' as $0;

export 'components.pb.dart';

@$pb.GrpcServiceName('ComponentSevice')
class ComponentSeviceClient extends $grpc.Client {
  static final _$getAllComponents = $grpc.ClientMethod<$0.Empty, $0.ComponentList>(
      '/ComponentSevice/GetAllComponents',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ComponentList.fromBuffer(value));
  static final _$addComponent = $grpc.ClientMethod<$0.ComponentRequest, $0.ComponentResponse>(
      '/ComponentSevice/AddComponent',
      ($0.ComponentRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ComponentResponse.fromBuffer(value));
  static final _$loadComponentsFromJson = $grpc.ClientMethod<$0.Empty, $0.ComponentResponse>(
      '/ComponentSevice/LoadComponentsFromJson',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ComponentResponse.fromBuffer(value));

  ComponentSeviceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.ComponentList> getAllComponents($0.Empty request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getAllComponents, request, options: options);
  }

  $grpc.ResponseFuture<$0.ComponentResponse> addComponent($0.ComponentRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$addComponent, request, options: options);
  }

  $grpc.ResponseFuture<$0.ComponentResponse> loadComponentsFromJson($0.Empty request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$loadComponentsFromJson, request, options: options);
  }
}

@$pb.GrpcServiceName('ComponentSevice')
abstract class ComponentSeviceServiceBase extends $grpc.Service {
  $core.String get $name => 'ComponentSevice';

  ComponentSeviceServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.ComponentList>(
        'GetAllComponents',
        getAllComponents_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.ComponentList value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ComponentRequest, $0.ComponentResponse>(
        'AddComponent',
        addComponent_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ComponentRequest.fromBuffer(value),
        ($0.ComponentResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.ComponentResponse>(
        'LoadComponentsFromJson',
        loadComponentsFromJson_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.ComponentResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.ComponentList> getAllComponents_Pre($grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return getAllComponents($call, await $request);
  }

  $async.Future<$0.ComponentResponse> addComponent_Pre($grpc.ServiceCall $call, $async.Future<$0.ComponentRequest> $request) async {
    return addComponent($call, await $request);
  }

  $async.Future<$0.ComponentResponse> loadComponentsFromJson_Pre($grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return loadComponentsFromJson($call, await $request);
  }

  $async.Future<$0.ComponentList> getAllComponents($grpc.ServiceCall call, $0.Empty request);
  $async.Future<$0.ComponentResponse> addComponent($grpc.ServiceCall call, $0.ComponentRequest request);
  $async.Future<$0.ComponentResponse> loadComponentsFromJson($grpc.ServiceCall call, $0.Empty request);
}
