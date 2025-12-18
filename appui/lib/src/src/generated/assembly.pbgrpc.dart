//
//  Generated code. Do not modify.
//  source: assembly.proto
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

import 'assembly.pb.dart' as $0;

export 'assembly.pb.dart';

@$pb.GrpcServiceName('BuildService')
class BuildServiceClient extends $grpc.Client {
  static final _$getOneBuild = $grpc.ClientMethod<$0.Empty, $0.Build>(
      '/BuildService/GetOneBuild',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Build.fromBuffer(value));

  BuildServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.Build> getOneBuild($0.Empty request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getOneBuild, request, options: options);
  }
}

@$pb.GrpcServiceName('BuildService')
abstract class BuildServiceBase extends $grpc.Service {
  $core.String get $name => 'BuildService';

  BuildServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.Build>(
        'GetOneBuild',
        getOneBuild_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.Build value) => value.writeToBuffer()));
  }

  $async.Future<$0.Build> getOneBuild_Pre($grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return getOneBuild($call, await $request);
  }

  $async.Future<$0.Build> getOneBuild($grpc.ServiceCall call, $0.Empty request);
}
