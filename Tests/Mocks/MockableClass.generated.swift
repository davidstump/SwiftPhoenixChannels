//// Generated using Sourcery 2.2.6 — https://github.com/krzysztofzablocki/Sourcery
//// DO NOT EDIT
//// swiftlint:disable line_length
//// swiftlint:disable variable_name
//
//@testable import SwiftPhoenixClient
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//class ChannelMock: Channel {
//    var socketSetCount: Int = 0
//    var socketDidGetSet: Bool { return socketSetCount > 0 }
//    override var socket: Socket? {
//        didSet { socketSetCount += 1 }
//    }
//    override var state: ChannelState {
//        get { return underlyingState }
//        set(value) { underlyingState = value }
//    }
//    var underlyingState: (ChannelState)!
//    override var bindingRef: Int {
//        get { return underlyingBindingRef }
//        set(value) { underlyingBindingRef = value }
//    }
//    var underlyingBindingRef: (Int)!
//    override var timeout: TimeInterval {
//        get { return underlyingTimeout }
//        set(value) { underlyingTimeout = value }
//    }
//    var underlyingTimeout: (TimeInterval)!
//    override var joinedOnce: Bool {
//        get { return underlyingJoinedOnce }
//        set(value) { underlyingJoinedOnce = value }
//    }
//    var underlyingJoinedOnce: (Bool)!
//    var joinPushSetCount: Int = 0
//    var joinPushDidGetSet: Bool { return joinPushSetCount > 0 }
//    override var joinPush: Push! {
//        didSet { joinPushSetCount += 1 }
//    }
//    override var rejoinTimer: TimeoutTimer {
//        get { return underlyingRejoinTimer }
//        set(value) { underlyingRejoinTimer = value }
//    }
//    var underlyingRejoinTimer: (TimeoutTimer)!
//    override var onMessage: (_ message: IncomingMessage) -> IncomingMessage {
//        get { return underlyingOnMessage }
//        set(value) { underlyingOnMessage = value }
//    }
//    var underlyingOnMessage: ((_ message: IncomingMessage) -> IncomingMessage)!
//
//
//    //MARK: - init
//
//    var initTopicParamsSocketReceivedArguments: (topic: String, params: [String: Any], socket: Socket)?
//    var initTopicParamsSocketClosure: ((String, [String: Any], Socket) -> Void)?
//
//
//    //MARK: - deinit
//
//    var deinitCallsCount = 0
//    var deinitCalled: Bool {
//        return deinitCallsCount > 0
//    }
//    var deinitClosure: (() -> Void)?
//
//
//    //MARK: - join
//
//    var joinTimeoutCallsCount = 0
//    var joinTimeoutCalled: Bool {
//        return joinTimeoutCallsCount > 0
//    }
//    var joinTimeoutReceivedTimeout: TimeInterval?
//    var joinTimeoutReturnValue: Push!
//    var joinTimeoutClosure: ((TimeInterval?) -> Push)?
//
//    override func join(timeout: TimeInterval? = nil) -> Push {
//        joinTimeoutCallsCount += 1
//        joinTimeoutReceivedTimeout = timeout
//        return joinTimeoutClosure.map({ $0(timeout) }) ?? joinTimeoutReturnValue
//    }
//
//
//    //MARK: - _on
//
//    var _OnCallbackCallsCount = 0
//    var _OnCallbackCalled: Bool {
//        return _OnCallbackCallsCount > 0
//    }
//    var _OnCallbackReceivedArguments: (event: String, callback: (IncomingMessage) -> Void)?
//    var _OnCallbackReturnValue: Int!
//    var _OnCallbackClosure: ((String, @escaping (IncomingMessage) -> Void) -> Int)?
//
//    override func _on(_ event: String, callback: @escaping (IncomingMessage) -> Void) -> Int {
//        _OnCallbackCallsCount += 1
//    _OnCallbackReceivedArguments = (event: event, callback: callback)
//        return _OnCallbackClosure.map({ $0(event, callback) }) ?? _OnCallbackReturnValue
//    }
//
//
//    //MARK: - off
//
//    var offRefCallsCount = 0
//    var offRefCalled: Bool {
//        return offRefCallsCount > 0
//    }
//    var offRefReceivedArguments: (event: String, ref: Int?)?
//    var offRefClosure: ((String, Int?) -> Void)?
//
//    override func off(_ event: String, ref: Int? = nil) {
//        offRefCallsCount += 1
//    offRefReceivedArguments = (event: event, ref: ref)
//        offRefClosure?(event, ref)
//    }
//
//
//    //MARK: - push
//
//    var pushPayloadTimeoutCallsCount = 0
//    var pushPayloadTimeoutCalled: Bool {
//        return pushPayloadTimeoutCallsCount > 0
//    }
//    var pushPayloadTimeoutReceivedArguments: (event: String, payload: Payload, timeout: TimeInterval)?
//    var pushPayloadTimeoutReturnValue: Push!
//    var pushPayloadTimeoutClosure: ((String, Payload, TimeInterval) -> Push)?
//
//    override func push(_ event: String, payload: Payload, timeout: TimeInterval = Defaults.timeoutInterval) -> Push {
//        pushPayloadTimeoutCallsCount += 1
//    pushPayloadTimeoutReceivedArguments = (event: event, payload: payload, timeout: timeout)
//        return pushPayloadTimeoutClosure.map({ $0(event, payload, timeout) }) ?? pushPayloadTimeoutReturnValue
//    }
//
//
//    //MARK: - binaryPush
//
//    var binaryPushPayloadTimeoutCallsCount = 0
//    var binaryPushPayloadTimeoutCalled: Bool {
//        return binaryPushPayloadTimeoutCallsCount > 0
//    }
//    var binaryPushPayloadTimeoutReceivedArguments: (event: String, payload: Data, timeout: TimeInterval)?
//    var binaryPushPayloadTimeoutReturnValue: Push!
//    var binaryPushPayloadTimeoutClosure: ((String, Data, TimeInterval) -> Push)?
//
//    override func binaryPush(_ event: String, payload: Data, timeout: TimeInterval = Defaults.timeoutInterval) -> Push {
//        binaryPushPayloadTimeoutCallsCount += 1
//    binaryPushPayloadTimeoutReceivedArguments = (event: event, payload: payload, timeout: timeout)
//        return binaryPushPayloadTimeoutClosure.map({ $0(event, payload, timeout) }) ?? binaryPushPayloadTimeoutReturnValue
//    }
//
//
//    //MARK: - leave
//
//    var leaveTimeoutCallsCount = 0
//    var leaveTimeoutCalled: Bool {
//        return leaveTimeoutCallsCount > 0
//    }
//    var leaveTimeoutReceivedTimeout: TimeInterval?
//    var leaveTimeoutReturnValue: Push!
//    var leaveTimeoutClosure: ((TimeInterval) -> Push)?
//
//    override func leave(timeout: TimeInterval = Defaults.timeoutInterval) -> Push {
//        leaveTimeoutCallsCount += 1
//        leaveTimeoutReceivedTimeout = timeout
//        return leaveTimeoutClosure.map({ $0(timeout) }) ?? leaveTimeoutReturnValue
//    }
//
//
//    //MARK: - onMessage
//
//    var onMessageCallbackCallsCount = 0
//    var onMessageCallbackCalled: Bool {
//        return onMessageCallbackCallsCount > 0
//    }
//    var onMessageCallbackReceivedCallback: ((IncomingMessage) -> IncomingMessage)?
//    var onMessageCallbackClosure: ((@escaping (IncomingMessage) -> IncomingMessage) -> Void)?
//
//    override func onMessage(callback: @escaping (IncomingMessage) -> IncomingMessage) {
//        onMessageCallbackCallsCount += 1
//        onMessageCallbackReceivedCallback = callback
//        onMessageCallbackClosure?(callback)
//    }
//
//
//    //MARK: - isMember
//
//    var isMemberCallsCount = 0
//    var isMemberCalled: Bool {
//        return isMemberCallsCount > 0
//    }
//    var isMemberReceivedMessage: IncomingMessage?
//    var isMemberReturnValue: Bool!
//    var isMemberClosure: ((IncomingMessage) -> Bool)?
//
//    override func isMember(_ message: IncomingMessage) -> Bool {
//        isMemberCallsCount += 1
//        isMemberReceivedMessage = message
//        return isMemberClosure.map({ $0(message) }) ?? isMemberReturnValue
//    }
//
//
//    //MARK: - sendJoin
//
//    var sendJoinCallsCount = 0
//    var sendJoinCalled: Bool {
//        return sendJoinCallsCount > 0
//    }
//    var sendJoinReceivedTimeout: TimeInterval?
//    var sendJoinClosure: ((TimeInterval) -> Void)?
//
//    override func sendJoin(_ timeout: TimeInterval) {
//        sendJoinCallsCount += 1
//        sendJoinReceivedTimeout = timeout
//        sendJoinClosure?(timeout)
//    }
//
//
//    //MARK: - rejoin
//
//    var rejoinCallsCount = 0
//    var rejoinCalled: Bool {
//        return rejoinCallsCount > 0
//    }
//    var rejoinReceivedTimeout: TimeInterval?
//    var rejoinClosure: ((TimeInterval?) -> Void)?
//
//    override func rejoin(_ timeout: TimeInterval? = nil) {
//        rejoinCallsCount += 1
//        rejoinReceivedTimeout = timeout
//        rejoinClosure?(timeout)
//    }
//
//
//    //MARK: - trigger
//
//    var triggerEventPayloadStatusCallsCount = 0
//    var triggerEventPayloadStatusCalled: Bool {
//        return triggerEventPayloadStatusCallsCount > 0
//    }
//    var triggerEventPayloadStatusReceivedArguments: (event: String, payload: Payload, status: String?)?
//    var triggerEventPayloadStatusClosure: ((String, Payload, String?) -> Void)?
//
//    override func trigger(event: String, payload: Payload = [:], status: String? = nil) {
//        triggerEventPayloadStatusCallsCount += 1
//    triggerEventPayloadStatusReceivedArguments = (event: event, payload: payload, status: status)
//        triggerEventPayloadStatusClosure?(event, payload, status)
//    }
//
//
//    //MARK: - trigger
//
//    var triggerCallsCount = 0
//    var triggerCalled: Bool {
//        return triggerCallsCount > 0
//    }
//    var triggerReceivedIncomingMessage: IncomingMessage?
//    var triggerClosure: ((IncomingMessage) -> Void)?
//
//    override func trigger(_ incomingMessage: IncomingMessage) {
//        triggerCallsCount += 1
//        triggerReceivedIncomingMessage = incomingMessage
//        triggerClosure?(incomingMessage)
//    }
//
//
//    //MARK: - replyEventName
//
//    var replyEventNameCallsCount = 0
//    var replyEventNameCalled: Bool {
//        return replyEventNameCallsCount > 0
//    }
//    var replyEventNameReceivedRef: String?
//    var replyEventNameReturnValue: String!
//    var replyEventNameClosure: ((String) -> String)?
//
//    override func replyEventName(_ ref: String) -> String {
//        replyEventNameCallsCount += 1
//        replyEventNameReceivedRef = ref
//        return replyEventNameClosure.map({ $0(ref) }) ?? replyEventNameReturnValue
//    }
//
//
//}
//class PushMock: Push {
//    var channelSetCount: Int = 0
//    var channelDidGetSet: Bool { return channelSetCount > 0 }
//    override var channel: Channel? {
//        didSet { channelSetCount += 1 }
//    }
//    override var payload: OutgoingPayload {
//        get { return underlyingPayload }
//        set(value) { underlyingPayload = value }
//    }
//    var underlyingPayload: (OutgoingPayload)!
//    override var timeout: TimeInterval {
//        get { return underlyingTimeout }
//        set(value) { underlyingTimeout = value }
//    }
//    var underlyingTimeout: (TimeInterval)!
//    var receivedMessageSetCount: Int = 0
//    var receivedMessageDidGetSet: Bool { return receivedMessageSetCount > 0 }
//    override var receivedMessage: IncomingMessage? {
//        didSet { receivedMessageSetCount += 1 }
//    }
//    override var timeoutTimer: TimerQueue {
//        get { return underlyingTimeoutTimer }
//        set(value) { underlyingTimeoutTimer = value }
//    }
//    var underlyingTimeoutTimer: (TimerQueue)!
//    var timeoutWorkItemSetCount: Int = 0
//    var timeoutWorkItemDidGetSet: Bool { return timeoutWorkItemSetCount > 0 }
//    override var timeoutWorkItem: DispatchWorkItem? {
//        didSet { timeoutWorkItemSetCount += 1 }
//    }
//    override var receiveHooks: SynchronizedArray<ReceiveHook> {
//        get { return underlyingReceiveHooks }
//        set(value) { underlyingReceiveHooks = value }
//    }
//    var underlyingReceiveHooks: (SynchronizedArray<ReceiveHook>)!
//    override var sent: Bool {
//        get { return underlyingSent }
//        set(value) { underlyingSent = value }
//    }
//    var underlyingSent: (Bool)!
//    var refSetCount: Int = 0
//    var refDidGetSet: Bool { return refSetCount > 0 }
//    override var ref: String? {
//        didSet { refSetCount += 1 }
//    }
//    var refEventSetCount: Int = 0
//    var refEventDidGetSet: Bool { return refEventSetCount > 0 }
//    override var refEvent: String? {
//        didSet { refEventSetCount += 1 }
//    }
//
//
//    //MARK: - init
//
//    var initChannelEventPayloadTimeoutReceivedArguments: (channel: Channel, event: String, payload: OutgoingPayload, timeout: TimeInterval)?
//    var initChannelEventPayloadTimeoutClosure: ((Channel, String, OutgoingPayload, TimeInterval) -> Void)?
//
//
//    //MARK: - resend
//
//    var resendCallsCount = 0
//    var resendCalled: Bool {
//        return resendCallsCount > 0
//    }
//    var resendReceivedTimeout: TimeInterval?
//    var resendClosure: ((TimeInterval) -> Void)?
//
//    override func resend(_ timeout: TimeInterval = Defaults.timeoutInterval) {
//        resendCallsCount += 1
//        resendReceivedTimeout = timeout
//        resendClosure?(timeout)
//    }
//
//
//    //MARK: - send
//
//    var sendCallsCount = 0
//    var sendCalled: Bool {
//        return sendCallsCount > 0
//    }
//    var sendClosure: (() -> Void)?
//
//    override func send() {
//        sendCallsCount += 1
//        sendClosure?()
//    }
//
//
//    //MARK: - receive
//
//    var receiveCallbackCallsCount = 0
//    var receiveCallbackCalled: Bool {
//        return receiveCallbackCallsCount > 0
//    }
//    var receiveCallbackReceivedArguments: (status: String, callback: (ChannelMessage<Any>) -> Void)?
//    var receiveCallbackReturnValue: Push!
//    var receiveCallbackClosure: ((String, @escaping (ChannelMessage<Any>) -> Void) -> Push)?
//
//    override func receive(_ status: String, callback: @escaping (ChannelMessage<Any>) -> Void) -> Push {
//        receiveCallbackCallsCount += 1
//    receiveCallbackReceivedArguments = (status: status, callback: callback)
//        return receiveCallbackClosure.map({ $0(status, callback) }) ?? receiveCallbackReturnValue
//    }
//
//
//    //MARK: - receiveData
//
//    var receiveDataCallbackCallsCount = 0
//    var receiveDataCallbackCalled: Bool {
//        return receiveDataCallbackCallsCount > 0
//    }
//    var receiveDataCallbackReceivedArguments: (status: String, callback: (ChannelMessage<Data>) -> Void)?
//    var receiveDataCallbackReturnValue: Push!
//    var receiveDataCallbackClosure: ((String, @escaping (ChannelMessage<Data>) -> Void) -> Push)?
//
//    override func receiveData(_ status: String, callback: @escaping (ChannelMessage<Data>) -> Void) -> Push {
//        receiveDataCallbackCallsCount += 1
//    receiveDataCallbackReceivedArguments = (status: status, callback: callback)
//        return receiveDataCallbackClosure.map({ $0(status, callback) }) ?? receiveDataCallbackReturnValue
//    }
//
//
//    //MARK: - receiveDecodable<T: Codable>
//
//    var receiveDecodableOfCallbackCallsCount = 0
//    var receiveDecodableOfCallbackCalled: Bool {
//        return receiveDecodableOfCallbackCallsCount > 0
//    }
//    var receiveDecodableOfCallbackReturnValue: Push!
//
//    override func receiveDecodable<T: Codable>(_ status: String, of type: T.Type, callback: @escaping (ChannelMessage<T>) -> Void) -> Push {
//        receiveDecodableOfCallbackCallsCount += 1
//        return receiveDecodableOfCallbackReturnValue
//    }
//
//
//    //MARK: - _receive
//
//    var _ReceiveCallbackCallsCount = 0
//    var _ReceiveCallbackCalled: Bool {
//        return _ReceiveCallbackCallsCount > 0
//    }
//    var _ReceiveCallbackReceivedArguments: (status: String, callback: (IncomingMessage) -> Void)?
//    var _ReceiveCallbackReturnValue: Push!
//    var _ReceiveCallbackClosure: ((String, @escaping (IncomingMessage) -> Void) -> Push)?
//
//    override func _receive(_ status: String, callback: @escaping (IncomingMessage) -> Void) -> Push {
//        _ReceiveCallbackCallsCount += 1
//    _ReceiveCallbackReceivedArguments = (status: status, callback: callback)
//        return _ReceiveCallbackClosure.map({ $0(status, callback) }) ?? _ReceiveCallbackReturnValue
//    }
//
//
//    //MARK: - reset
//
//    var resetCallsCount = 0
//    var resetCalled: Bool {
//        return resetCallsCount > 0
//    }
//    var resetClosure: (() -> Void)?
//
//    override func reset() {
//        resetCallsCount += 1
//        resetClosure?()
//    }
//
//
//    //MARK: - cancelTimeout
//
//    var cancelTimeoutCallsCount = 0
//    var cancelTimeoutCalled: Bool {
//        return cancelTimeoutCallsCount > 0
//    }
//    var cancelTimeoutClosure: (() -> Void)?
//
//    override func cancelTimeout() {
//        cancelTimeoutCallsCount += 1
//        cancelTimeoutClosure?()
//    }
//
//
//    //MARK: - startTimeout
//
//    var startTimeoutCallsCount = 0
//    var startTimeoutCalled: Bool {
//        return startTimeoutCallsCount > 0
//    }
//    var startTimeoutClosure: (() -> Void)?
//
//    override func startTimeout() {
//        startTimeoutCallsCount += 1
//        startTimeoutClosure?()
//    }
//
//
//    //MARK: - hasReceived
//
//    var hasReceivedStatusCallsCount = 0
//    var hasReceivedStatusCalled: Bool {
//        return hasReceivedStatusCallsCount > 0
//    }
//    var hasReceivedStatusReceivedStatus: String?
//    var hasReceivedStatusReturnValue: Bool!
//    var hasReceivedStatusClosure: ((String) -> Bool)?
//
//    override func hasReceived(status: String) -> Bool {
//        hasReceivedStatusCallsCount += 1
//        hasReceivedStatusReceivedStatus = status
//        return hasReceivedStatusClosure.map({ $0(status) }) ?? hasReceivedStatusReturnValue
//    }
//
//
//    //MARK: - trigger
//
//    var triggerPayloadCallsCount = 0
//    var triggerPayloadCalled: Bool {
//        return triggerPayloadCallsCount > 0
//    }
//    var triggerPayloadReceivedArguments: (status: String, payload: Payload)?
//    var triggerPayloadClosure: ((String, Payload) -> Void)?
//
//    override func trigger(_ status: String, payload: Payload) {
//        triggerPayloadCallsCount += 1
//    triggerPayloadReceivedArguments = (status: status, payload: payload)
//        triggerPayloadClosure?(status, payload)
//    }
//
//
//}
//class SocketMock: Socket {
//    override var vsn: String {
//        get { return underlyingVsn }
//        set(value) { underlyingVsn = value }
//    }
//    var underlyingVsn: (String)!
//    override var serializer: TransportSerializer {
//        get { return underlyingSerializer }
//        set(value) { underlyingSerializer = value }
//    }
//    var underlyingSerializer: (TransportSerializer)!
//    override var encoder: PayloadEncoder {
//        get { return underlyingEncoder }
//        set(value) { underlyingEncoder = value }
//    }
//    var underlyingEncoder: (PayloadEncoder)!
//    override var decoder: PayloadDecoder {
//        get { return underlyingDecoder }
//        set(value) { underlyingDecoder = value }
//    }
//    var underlyingDecoder: (PayloadDecoder)!
//    override var timeout: TimeInterval {
//        get { return underlyingTimeout }
//        set(value) { underlyingTimeout = value }
//    }
//    var underlyingTimeout: (TimeInterval)!
//    override var heartbeatInterval: TimeInterval {
//        get { return underlyingHeartbeatInterval }
//        set(value) { underlyingHeartbeatInterval = value }
//    }
//    var underlyingHeartbeatInterval: (TimeInterval)!
//    override var heartbeatLeeway: DispatchTimeInterval {
//        get { return underlyingHeartbeatLeeway }
//        set(value) { underlyingHeartbeatLeeway = value }
//    }
//    var underlyingHeartbeatLeeway: (DispatchTimeInterval)!
//    override var reconnectAfter: SteppedBackoff {
//        get { return underlyingReconnectAfter }
//        set(value) { underlyingReconnectAfter = value }
//    }
//    var underlyingReconnectAfter: (SteppedBackoff)!
//    override var rejoinAfter: SteppedBackoff {
//        get { return underlyingRejoinAfter }
//        set(value) { underlyingRejoinAfter = value }
//    }
//    var underlyingRejoinAfter: (SteppedBackoff)!
//    var loggerSetCount: Int = 0
//    var loggerDidGetSet: Bool { return loggerSetCount > 0 }
//    override var logger: ((String) -> Void)? {
//        didSet { loggerSetCount += 1 }
//    }
//    override var skipHeartbeat: Bool {
//        get { return underlyingSkipHeartbeat }
//        set(value) { underlyingSkipHeartbeat = value }
//    }
//    var underlyingSkipHeartbeat: (Bool)!
//    override var ref: UInt64 {
//        get { return underlyingRef }
//        set(value) { underlyingRef = value }
//    }
//    var underlyingRef: (UInt64)!
//    var heartbeatTimerSetCount: Int = 0
//    var heartbeatTimerDidGetSet: Bool { return heartbeatTimerSetCount > 0 }
//    override var heartbeatTimer: HeartbeatTimer? {
//        didSet { heartbeatTimerSetCount += 1 }
//    }
//    var pendingHeartbeatRefSetCount: Int = 0
//    var pendingHeartbeatRefDidGetSet: Bool { return pendingHeartbeatRefSetCount > 0 }
//    override var pendingHeartbeatRef: String? {
//        didSet { pendingHeartbeatRefSetCount += 1 }
//    }
//    override var reconnectTimer: ScheduleTimer {
//        get { return underlyingReconnectTimer }
//        set(value) { underlyingReconnectTimer = value }
//    }
//    var underlyingReconnectTimer: (ScheduleTimer)!
//    var closeStatusSetCount: Int = 0
//    var closeStatusDidGetSet: Bool { return closeStatusSetCount > 0 }
//    override var closeStatus: URLSessionWebSocketTask.CloseCode? {
//        didSet { closeStatusSetCount += 1 }
//    }
//    var connectionSetCount: Int = 0
//    var connectionDidGetSet: Bool { return connectionSetCount > 0 }
//    override var connection: Transport? {
//        didSet { connectionSetCount += 1 }
//    }
//
//
//    //MARK: - init
//
//    var initParamsReceivedArguments: (endPoint: String, params: Payload?)?
//    var initParamsClosure: ((String, Payload?) -> Void)?
//
//
//    //MARK: - init
//
//    var initParamsReceivedArguments: (endPoint: String, params: PayloadClosure?)?
//    var initParamsClosure: ((String, PayloadClosure?) -> Void)?
//
//
//    //MARK: - init
//
//    var initEndPointTransportParamsReceivedArguments: (endPoint: String, transport: (URL) -> Transport, params: PayloadClosure?)?
//    var initEndPointTransportParamsClosure: ((String, @escaping (URL) -> Transport, PayloadClosure?) -> Void)?
//
//
//    //MARK: - deinit
//
//    var deinitCallsCount = 0
//    var deinitCalled: Bool {
//        return deinitCallsCount > 0
//    }
//    var deinitClosure: (() -> Void)?
//
//
//    //MARK: - connect
//
//    var connectCallsCount = 0
//    var connectCalled: Bool {
//        return connectCallsCount > 0
//    }
//    var connectClosure: (() -> Void)?
//
//    override func connect() {
//        connectCallsCount += 1
//        connectClosure?()
//    }
//
//
//    //MARK: - disconnect
//
//    var disconnectCodeReasonCallbackCallsCount = 0
//    var disconnectCodeReasonCallbackCalled: Bool {
//        return disconnectCodeReasonCallbackCallsCount > 0
//    }
//    var disconnectCodeReasonCallbackReceivedArguments: (code: URLSessionWebSocketTask.CloseCode, reason: String?, callback: (() -> Void)?)?
//    var disconnectCodeReasonCallbackClosure: ((URLSessionWebSocketTask.CloseCode, String?, (() -> Void)?) -> Void)?
//
//    override func disconnect(code: URLSessionWebSocketTask.CloseCode = .normalClosure, reason: String? = nil, callback: (() -> Void)? = nil) {
//        disconnectCodeReasonCallbackCallsCount += 1
//    disconnectCodeReasonCallbackReceivedArguments = (code: code, reason: reason, callback: callback)
//        disconnectCodeReasonCallbackClosure?(code, reason, callback)
//    }
//
//
//    //MARK: - teardown
//
//    var teardownCodeReasonCallbackCallsCount = 0
//    var teardownCodeReasonCallbackCalled: Bool {
//        return teardownCodeReasonCallbackCallsCount > 0
//    }
//    var teardownCodeReasonCallbackReceivedArguments: (code: URLSessionWebSocketTask.CloseCode, reason: String?, callback: (() -> Void)?)?
//    var teardownCodeReasonCallbackClosure: ((URLSessionWebSocketTask.CloseCode, String?, (() -> Void)?) -> Void)?
//
//    override func teardown(code: URLSessionWebSocketTask.CloseCode = .normalClosure, reason: String? = nil, callback: (() -> Void)? = nil) {
//        teardownCodeReasonCallbackCallsCount += 1
//    teardownCodeReasonCallbackReceivedArguments = (code: code, reason: reason, callback: callback)
//        teardownCodeReasonCallbackClosure?(code, reason, callback)
//    }
//
//
//    //MARK: - onOpen
//
//    var onOpenCallbackCallsCount = 0
//    var onOpenCallbackCalled: Bool {
//        return onOpenCallbackCallsCount > 0
//    }
//    var onOpenCallbackReceivedCallback: (() -> Void)?
//    var onOpenCallbackReturnValue: String!
//    var onOpenCallbackClosure: ((@escaping () -> Void) -> String)?
//
//    override func onOpen(callback: @escaping () -> Void) -> String {
//        onOpenCallbackCallsCount += 1
//        onOpenCallbackReceivedCallback = callback
//        return onOpenCallbackClosure.map({ $0(callback) }) ?? onOpenCallbackReturnValue
//    }
//
//
//    //MARK: - onOpen
//
//    var onOpenCallbackCallsCount = 0
//    var onOpenCallbackCalled: Bool {
//        return onOpenCallbackCallsCount > 0
//    }
//    var onOpenCallbackReceivedCallback: ((URLResponse?) -> Void)?
//    var onOpenCallbackReturnValue: String!
//    var onOpenCallbackClosure: ((@escaping (URLResponse?) -> Void) -> String)?
//
//    override func onOpen(callback: @escaping (URLResponse?) -> Void) -> String {
//        onOpenCallbackCallsCount += 1
//        onOpenCallbackReceivedCallback = callback
//        return onOpenCallbackClosure.map({ $0(callback) }) ?? onOpenCallbackReturnValue
//    }
//
//
//    //MARK: - onClose
//
//    var onCloseCallbackCallsCount = 0
//    var onCloseCallbackCalled: Bool {
//        return onCloseCallbackCallsCount > 0
//    }
//    var onCloseCallbackReceivedCallback: (() -> Void)?
//    var onCloseCallbackReturnValue: String!
//    var onCloseCallbackClosure: ((@escaping () -> Void) -> String)?
//
//    override func onClose(callback: @escaping () -> Void) -> String {
//        onCloseCallbackCallsCount += 1
//        onCloseCallbackReceivedCallback = callback
//        return onCloseCallbackClosure.map({ $0(callback) }) ?? onCloseCallbackReturnValue
//    }
//
//
//    //MARK: - onClose
//
//    var onCloseCallbackCallsCount = 0
//    var onCloseCallbackCalled: Bool {
//        return onCloseCallbackCallsCount > 0
//    }
//    var onCloseCallbackReceivedCallback: ((URLSessionWebSocketTask.CloseCode, String?) -> Void)?
//    var onCloseCallbackReturnValue: String!
//    var onCloseCallbackClosure: ((@escaping (URLSessionWebSocketTask.CloseCode, String?) -> Void) -> String)?
//
//    override func onClose(callback: @escaping (URLSessionWebSocketTask.CloseCode, String?) -> Void) -> String {
//        onCloseCallbackCallsCount += 1
//        onCloseCallbackReceivedCallback = callback
//        return onCloseCallbackClosure.map({ $0(callback) }) ?? onCloseCallbackReturnValue
//    }
//
//
//    //MARK: - onError
//
//    var onErrorCallbackCallsCount = 0
//    var onErrorCallbackCalled: Bool {
//        return onErrorCallbackCallsCount > 0
//    }
//    var onErrorCallbackReceivedCallback: ((Error, URLResponse?) -> Void)?
//    var onErrorCallbackReturnValue: String!
//    var onErrorCallbackClosure: ((@escaping (Error, URLResponse?) -> Void) -> String)?
//
//    override func onError(callback: @escaping (Error, URLResponse?) -> Void) -> String {
//        onErrorCallbackCallsCount += 1
//        onErrorCallbackReceivedCallback = callback
//        return onErrorCallbackClosure.map({ $0(callback) }) ?? onErrorCallbackReturnValue
//    }
//
//
//    //MARK: - onMessage
//
//    var onMessageCallbackCallsCount = 0
//    var onMessageCallbackCalled: Bool {
//        return onMessageCallbackCallsCount > 0
//    }
//    var onMessageCallbackReceivedCallback: ((IncomingMessage) -> Void)?
//    var onMessageCallbackReturnValue: String!
//    var onMessageCallbackClosure: ((@escaping (IncomingMessage) -> Void) -> String)?
//
//    override func onMessage(callback: @escaping (IncomingMessage) -> Void) -> String {
//        onMessageCallbackCallsCount += 1
//        onMessageCallbackReceivedCallback = callback
//        return onMessageCallbackClosure.map({ $0(callback) }) ?? onMessageCallbackReturnValue
//    }
//
//
//    //MARK: - releaseCallbacks
//
//    var releaseCallbacksCallsCount = 0
//    var releaseCallbacksCalled: Bool {
//        return releaseCallbacksCallsCount > 0
//    }
//    var releaseCallbacksClosure: (() -> Void)?
//
//    override func releaseCallbacks() {
//        releaseCallbacksCallsCount += 1
//        releaseCallbacksClosure?()
//    }
//
//
//    //MARK: - channel
//
//    var channelParamsCallsCount = 0
//    var channelParamsCalled: Bool {
//        return channelParamsCallsCount > 0
//    }
//    var channelParamsReceivedArguments: (topic: String, params: [String: Any])?
//    var channelParamsReturnValue: Channel!
//    var channelParamsClosure: ((String, [String: Any]) -> Channel)?
//
//    override func channel(_ topic: String, params: [String: Any] = [:]) -> Channel {
//        channelParamsCallsCount += 1
//    channelParamsReceivedArguments = (topic: topic, params: params)
//        return channelParamsClosure.map({ $0(topic, params) }) ?? channelParamsReturnValue
//    }
//
//
//    //MARK: - remove
//
//    var removeCallsCount = 0
//    var removeCalled: Bool {
//        return removeCallsCount > 0
//    }
//    var removeReceivedChannel: Channel?
//    var removeClosure: ((Channel) -> Void)?
//
//    override func remove(_ channel: Channel) {
//        removeCallsCount += 1
//        removeReceivedChannel = channel
//        removeClosure?(channel)
//    }
//
//
//    //MARK: - off
//
//    var offCallsCount = 0
//    var offCalled: Bool {
//        return offCallsCount > 0
//    }
//    var offReceivedRefs: [String]?
//    var offClosure: (([String]) -> Void)?
//
//    override func off(_ refs: [String]) {
//        offCallsCount += 1
//        offReceivedRefs = refs
//        offClosure?(refs)
//    }
//
//
//    //MARK: - push
//
//    var pushOutgoingCallsCount = 0
//    var pushOutgoingCalled: Bool {
//        return pushOutgoingCallsCount > 0
//    }
//    var pushOutgoingReceivedMessage: OutgoingMessage?
//    var pushOutgoingClosure: ((OutgoingMessage) -> Void)?
//
//    override func push(outgoing message: OutgoingMessage) {
//        pushOutgoingCallsCount += 1
//        pushOutgoingReceivedMessage = message
//        pushOutgoingClosure?(message)
//    }
//
//
//    //MARK: - makeRef
//
//    var makeRefCallsCount = 0
//    var makeRefCalled: Bool {
//        return makeRefCallsCount > 0
//    }
//    var makeRefReturnValue: String!
//    var makeRefClosure: (() -> String)?
//
//    override func makeRef() -> String {
//        makeRefCallsCount += 1
//        return makeRefClosure.map({ $0() }) ?? makeRefReturnValue
//    }
//
//
//    //MARK: - logItems
//
//    var logItemsCallsCount = 0
//    var logItemsCalled: Bool {
//        return logItemsCallsCount > 0
//    }
//    var logItemsReceivedItems: Any?
//    var logItemsClosure: ((Any) -> Void)?
//
//    override func logItems(_ items: Any...) {
//        logItemsCallsCount += 1
//        logItemsReceivedItems = items
//        logItemsClosure?(items)
//    }
//
//
//    //MARK: - onConnectionOpen
//
//    var onConnectionOpenResponseCallsCount = 0
//    var onConnectionOpenResponseCalled: Bool {
//        return onConnectionOpenResponseCallsCount > 0
//    }
//    var onConnectionOpenResponseReceivedResponse: URLResponse?
//    var onConnectionOpenResponseClosure: ((URLResponse?) -> Void)?
//
//    override func onConnectionOpen(response: URLResponse?) {
//        onConnectionOpenResponseCallsCount += 1
//        onConnectionOpenResponseReceivedResponse = response
//        onConnectionOpenResponseClosure?(response)
//    }
//
//
//    //MARK: - onConnectionClosed
//
//    var onConnectionClosedCodeReasonCallsCount = 0
//    var onConnectionClosedCodeReasonCalled: Bool {
//        return onConnectionClosedCodeReasonCallsCount > 0
//    }
//    var onConnectionClosedCodeReasonReceivedArguments: (code: URLSessionWebSocketTask.CloseCode, reason: String?)?
//    var onConnectionClosedCodeReasonClosure: ((URLSessionWebSocketTask.CloseCode, String?) -> Void)?
//
//    override func onConnectionClosed(code: URLSessionWebSocketTask.CloseCode, reason: String?) {
//        onConnectionClosedCodeReasonCallsCount += 1
//    onConnectionClosedCodeReasonReceivedArguments = (code: code, reason: reason)
//        onConnectionClosedCodeReasonClosure?(code, reason)
//    }
//
//
//    //MARK: - onConnectionError
//
//    var onConnectionErrorResponseCallsCount = 0
//    var onConnectionErrorResponseCalled: Bool {
//        return onConnectionErrorResponseCallsCount > 0
//    }
//    var onConnectionErrorResponseReceivedArguments: (error: Error, response: URLResponse?)?
//    var onConnectionErrorResponseClosure: ((Error, URLResponse?) -> Void)?
//
//    override func onConnectionError(_ error: Error, response: URLResponse?) {
//        onConnectionErrorResponseCallsCount += 1
//    onConnectionErrorResponseReceivedArguments = (error: error, response: response)
//        onConnectionErrorResponseClosure?(error, response)
//    }
//
//
//    //MARK: - onConnectionMessage
//
//    var onConnectionMessageCallsCount = 0
//    var onConnectionMessageCalled: Bool {
//        return onConnectionMessageCallsCount > 0
//    }
//    var onConnectionMessageReceivedMessage: IncomingMessage?
//    var onConnectionMessageClosure: ((IncomingMessage) -> Void)?
//
//    override func onConnectionMessage(_ message: IncomingMessage) {
//        onConnectionMessageCallsCount += 1
//        onConnectionMessageReceivedMessage = message
//        onConnectionMessageClosure?(message)
//    }
//
//
//    //MARK: - triggerChannelError
//
//    var triggerChannelErrorCallsCount = 0
//    var triggerChannelErrorCalled: Bool {
//        return triggerChannelErrorCallsCount > 0
//    }
//    var triggerChannelErrorClosure: (() -> Void)?
//
//    override func triggerChannelError() {
//        triggerChannelErrorCallsCount += 1
//        triggerChannelErrorClosure?()
//    }
//
//
//    //MARK: - flushSendBuffer
//
//    var flushSendBufferCallsCount = 0
//    var flushSendBufferCalled: Bool {
//        return flushSendBufferCallsCount > 0
//    }
//    var flushSendBufferClosure: (() -> Void)?
//
//    override func flushSendBuffer() {
//        flushSendBufferCallsCount += 1
//        flushSendBufferClosure?()
//    }
//
//
//    //MARK: - removeFromSendBuffer
//
//    var removeFromSendBufferRefCallsCount = 0
//    var removeFromSendBufferRefCalled: Bool {
//        return removeFromSendBufferRefCallsCount > 0
//    }
//    var removeFromSendBufferRefReceivedRef: String?
//    var removeFromSendBufferRefClosure: ((String) -> Void)?
//
//    override func removeFromSendBuffer(ref: String) {
//        removeFromSendBufferRefCallsCount += 1
//        removeFromSendBufferRefReceivedRef = ref
//        removeFromSendBufferRefClosure?(ref)
//    }
//
//
//    //MARK: - leaveOpenTopic
//
//    var leaveOpenTopicTopicCallsCount = 0
//    var leaveOpenTopicTopicCalled: Bool {
//        return leaveOpenTopicTopicCallsCount > 0
//    }
//    var leaveOpenTopicTopicReceivedTopic: String?
//    var leaveOpenTopicTopicClosure: ((String) -> Void)?
//
//    override func leaveOpenTopic(topic: String) {
//        leaveOpenTopicTopicCallsCount += 1
//        leaveOpenTopicTopicReceivedTopic = topic
//        leaveOpenTopicTopicClosure?(topic)
//    }
//
//
//    //MARK: - resetHeartbeat
//
//    var resetHeartbeatCallsCount = 0
//    var resetHeartbeatCalled: Bool {
//        return resetHeartbeatCallsCount > 0
//    }
//    var resetHeartbeatClosure: (() -> Void)?
//
//    override func resetHeartbeat() {
//        resetHeartbeatCallsCount += 1
//        resetHeartbeatClosure?()
//    }
//
//
//    //MARK: - sendHeartbeat
//
//    var sendHeartbeatCallsCount = 0
//    var sendHeartbeatCalled: Bool {
//        return sendHeartbeatCallsCount > 0
//    }
//    var sendHeartbeatClosure: (() -> Void)?
//
//    override func sendHeartbeat() {
//        sendHeartbeatCallsCount += 1
//        sendHeartbeatClosure?()
//    }
//
//
//    //MARK: - abnormalClose
//
//    var abnormalCloseCallsCount = 0
//    var abnormalCloseCalled: Bool {
//        return abnormalCloseCallsCount > 0
//    }
//    var abnormalCloseReceivedReason: String?
//    var abnormalCloseClosure: ((String) -> Void)?
//
//    override func abnormalClose(_ reason: String) {
//        abnormalCloseCallsCount += 1
//        abnormalCloseReceivedReason = reason
//        abnormalCloseClosure?(reason)
//    }
//
//
//    //MARK: - onOpen
//
//    var onOpenResponseCallsCount = 0
//    var onOpenResponseCalled: Bool {
//        return onOpenResponseCallsCount > 0
//    }
//    var onOpenResponseReceivedResponse: URLResponse?
//    var onOpenResponseClosure: ((URLResponse?) -> Void)?
//
//    override func onOpen(response: URLResponse?) {
//        onOpenResponseCallsCount += 1
//        onOpenResponseReceivedResponse = response
//        onOpenResponseClosure?(response)
//    }
//
//
//    //MARK: - onError
//
//    var onErrorErrorResponseCallsCount = 0
//    var onErrorErrorResponseCalled: Bool {
//        return onErrorErrorResponseCallsCount > 0
//    }
//    var onErrorErrorResponseReceivedArguments: (error: Error, response: URLResponse?)?
//    var onErrorErrorResponseClosure: ((Error, URLResponse?) -> Void)?
//
//    override func onError(error: Error, response: URLResponse?) {
//        onErrorErrorResponseCallsCount += 1
//    onErrorErrorResponseReceivedArguments = (error: error, response: response)
//        onErrorErrorResponseClosure?(error, response)
//    }
//
//
//    //MARK: - onMessage
//
//    var onMessageDataCallsCount = 0
//    var onMessageDataCalled: Bool {
//        return onMessageDataCallsCount > 0
//    }
//    var onMessageDataReceivedData: Data?
//    var onMessageDataClosure: ((Data) -> Void)?
//
//    override func onMessage(data: Data) {
//        onMessageDataCallsCount += 1
//        onMessageDataReceivedData = data
//        onMessageDataClosure?(data)
//    }
//
//
//    //MARK: - onMessage
//
//    var onMessageStringCallsCount = 0
//    var onMessageStringCalled: Bool {
//        return onMessageStringCallsCount > 0
//    }
//    var onMessageStringReceivedString: String?
//    var onMessageStringClosure: ((String) -> Void)?
//
//    override func onMessage(string: String) {
//        onMessageStringCallsCount += 1
//        onMessageStringReceivedString = string
//        onMessageStringClosure?(string)
//    }
//
//
//    //MARK: - onClose
//
//    var onCloseCodeReasonCallsCount = 0
//    var onCloseCodeReasonCalled: Bool {
//        return onCloseCodeReasonCallsCount > 0
//    }
//    var onCloseCodeReasonReceivedArguments: (code: URLSessionWebSocketTask.CloseCode, reason: String?)?
//    var onCloseCodeReasonClosure: ((URLSessionWebSocketTask.CloseCode, String?) -> Void)?
//
//    override func onClose(code: URLSessionWebSocketTask.CloseCode, reason: String? = nil) {
//        onCloseCodeReasonCallsCount += 1
//    onCloseCodeReasonReceivedArguments = (code: code, reason: reason)
//        onCloseCodeReasonClosure?(code, reason)
//    }
//
//
//    //MARK: - onClose
//
//    var onCloseCodeReasonCallsCount = 0
//    var onCloseCodeReasonCalled: Bool {
//        return onCloseCodeReasonCallsCount > 0
//    }
//    var onCloseCodeReasonReceivedArguments: (code: URLSessionWebSocketTask.CloseCode, reason: String?)?
//    var onCloseCodeReasonClosure: ((URLSessionWebSocketTask.CloseCode, String?) -> Void)?
//
//    override func onClose(code: URLSessionWebSocketTask.CloseCode, reason: String?) {
//        onCloseCodeReasonCallsCount += 1
//    onCloseCodeReasonReceivedArguments = (code: code, reason: reason)
//        onCloseCodeReasonClosure?(code, reason)
//    }
//
//
//}
//class TimeoutTimerMock: TimeoutTimer {
//    var callbackSetCount: Int = 0
//    var callbackDidGetSet: Bool { return callbackSetCount > 0 }
//    override var callback: (() -> Void)? {
//        didSet { callbackSetCount += 1 }
//    }
//    var timerCalculationSetCount: Int = 0
//    var timerCalculationDidGetSet: Bool { return timerCalculationSetCount > 0 }
//    override var timerCalculation: ((Int) -> TimeInterval)? {
//        didSet { timerCalculationSetCount += 1 }
//    }
//    var workItemSetCount: Int = 0
//    var workItemDidGetSet: Bool { return workItemSetCount > 0 }
//    override var workItem: DispatchWorkItem? {
//        didSet { workItemSetCount += 1 }
//    }
//    override var tries: Int {
//        get { return underlyingTries }
//        set(value) { underlyingTries = value }
//    }
//    var underlyingTries: (Int)!
//    override var queue: TimerQueue {
//        get { return underlyingQueue }
//        set(value) { underlyingQueue = value }
//    }
//    var underlyingQueue: (TimerQueue)!
//
//
//    //MARK: - reset
//
//    var resetCallsCount = 0
//    var resetCalled: Bool {
//        return resetCallsCount > 0
//    }
//    var resetClosure: (() -> Void)?
//
//    override func reset() {
//        resetCallsCount += 1
//        resetClosure?()
//    }
//
//
//    //MARK: - scheduleTimeout
//
//    var scheduleTimeoutCallsCount = 0
//    var scheduleTimeoutCalled: Bool {
//        return scheduleTimeoutCallsCount > 0
//    }
//    var scheduleTimeoutClosure: (() -> Void)?
//
//    override func scheduleTimeout() {
//        scheduleTimeoutCallsCount += 1
//        scheduleTimeoutClosure?()
//    }
//
//
//}
