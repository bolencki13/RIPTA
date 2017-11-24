<h1>RIPTA hackathon project</h1>

http://realtime.ripta.com:81
https://docs.google.com/document/d/1R_z2R5R5MPeJ-LvGfD9gnQIlVLcpajqscvOUPUUu8Gs/edit#heading=h.mfqwwv47bwb7
http://hortonworks.com/


***GET BUSSES***
~~~~
[[RPTRequestHandler sharedHandler].delegate = self;
[[RPTRequestHandler sharedHandler] getBusses];

#pragma mark - RPTRequestHandlerDelegate
- (void)requestHandler:(RPTRequestHandler*)request didFindBus:(NSArray <RPTBus *> *)busses; /* Called when API request is successful  */
- (void)requestHandler:(RPTRequestHandler*)request didNotFindBussesWithError:(NSError *)error; /* Called when an error occures on trying to execute the API requet */
~~~~

***GET CURRENT LOCATION***
~~~~
[[RPTLocationManager sharedManager] getUserLocation:^(CLLocation *location) {
    // Called upon success CLLocation is passed
} error:^(NSError *error) {
    // Called upon error NSError is passed
}];
~~~~
