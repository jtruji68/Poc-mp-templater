import 'dart:typed_data';
import 'dart:js_interop';
import 'package:web/web.dart';

void downloadFile(Uint8List bytes, String fileName, String mimeType) {
  // Convert Dart's Uint8List to a JavaScript ArrayBuffer
  final buffer = bytes.buffer.toJS;

  // Wrap the ArrayBuffer in a JSArray<BlobPart>
  final blobParts = [buffer].toJS;

  // Create a Blob from the JSArray<BlobPart>
  final blob = Blob(blobParts, BlobPropertyBag(type: mimeType));

  // Generate a URL for the Blob
  final url = URL.createObjectURL(blob);

  // Create an anchor element and set its href to the Blob URL
  final anchor = document.createElement('a') as HTMLAnchorElement;
  anchor.href = url;
  anchor.download = fileName;

  // Append the anchor to the document, trigger a click, and then remove it
  document.body?.appendChild(anchor);
  anchor.click();
  anchor.remove();

  // Revoke the object URL to free up resources
  URL.revokeObjectURL(url);
}
