class ApiConstants {
  //The request succeeded.
  static int statusCode200 = 200;
  //The request succeeded, and a new resource was created as a result.
  static int statusCode201 = 201;
  //The request has been received but not yet acted upon.
  static int statusCode202 = 202;
  //This response code means the returned metadata is not exactly the same as is available from the origin server,
  static int statusCode203 = 203;
  //There is no content to send for this request, but the headers may be useful.
  static int statusCode204 = 204;
  // Tells the user agent to reset the document which sent this request.
  static int statusCode205 = 205;
//This response code is used when the Range header is sent from the client to request only part of a resource.
  static int statusCode206 = 206;
//Conveys information about multiple resources, for situations where multiple status codes might be appropriate.
  static int statusCode207 = 207;
//Used inside a <dav:propstat> response element to avoid repeatedly enumerating the internal members of multiple bindings to the same collection.
  static int statusCode208 = 208;
//The server has fulfilled a GET request for the resource, and the response is a representation of the result of one or more instance-manipulations applied to the current instance.
  static int statusCode226 = 226;
  //The server cannot or will not process the request due to something that is perceived to be a client error (e.g., malformed request syntax, invalid request message framing, or deceptive request routing).
  static int statusCode400 = 400;
  //Although the HTTP standard specifies "unauthorized", semantically this response means "unauthenticated". That is, the client must authenticate itself to get the requested response.
  static int statusCode401 = 401;
//This response code is reserved for future use. The initial aim for creating this code was using it for digital payment systems, however this status code is used very rarely and no standard convention exists.
  static int statusCode402 = 402;
  //The client does not have access rights to the content; that is, it is unauthorized, so the server is refusing to give the requested resource. Unlike 401 Unauthorized, the client's identity is known to the server.
  static int statusCode403 = 403;
  //The server cannot find the requested resource.
  static int statusCode404 = 404;
  //The request method is known by the server but is not supported by the target resource. For example, an API may not allow calling DELETE to remove a resource.
  static int statusCode405 = 405;
  //This response is sent when a request conflicts with the current state of the server.
  static int statusCode409 = 409;
  //The server has encountered a situation it does not know how to handle.

  static int statusCode500 = 500;

//The request method is not supported by the server and cannot be handled. The only methods that servers are required to support (and therefore that must not return this code) are GET and HEAD
  static int statusCode501 = 501;
//This error response means that the server, while working as a gateway to get a response needed to handle the request, got an invalid response.
  static int statusCode502 = 502;
}
