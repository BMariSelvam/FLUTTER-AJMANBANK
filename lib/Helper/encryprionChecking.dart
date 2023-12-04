import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/block/aes_fast.dart';
import 'package:pointycastle/block/modes/ecb.dart';
import 'package:pointycastle/padded_block_cipher/padded_block_cipher_impl.dart';
import 'package:pointycastle/paddings/pkcs7.dart';
import 'constants.dart';

class DecrptionClass {

 static String getDecryptedString(String instr) {
    try {
      var keyBytes = hexToBytes(Constants.encryptionKey);
      final skeySpec = PaddedBlockCipherParameters(
        KeyParameter(Uint8List.fromList(keyBytes)),
        null,
      );

      final cipher = PaddedBlockCipherImpl(
        PKCS7Padding(),
        ECBBlockCipher(AESFastEngine()),
      );

      cipher.init(false, skeySpec);

      if (instr != null && instr.isNotEmpty) {
        final paddedCiphertext = hexToBytes(instr);
        final plaintext = cipher.process(Uint8List.fromList(paddedCiphertext));
        String value = utf8.decode(plaintext);
        return value;
      } else {
        return '';
      }
    } catch (e) {
      print(e);
      return '';
    }
  }


  static List<int> hexToBytes(String hexString) {
    final i = hexString.length;
    Uint8List abyte0 = Uint8List((i + 1) ~/ 2);

    var j = 0;
    var k = 0;
    if (i % 2 == 1) {
      abyte0[k++] = hexFromDigit(hexString[j++]);
    }
    while (j < i) {
      abyte0[k++] =
          (hexFromDigit(hexString[j++]) << 4 | hexFromDigit(hexString[j++]));
    }
    Uint8List bytes = Uint8List.fromList(abyte0);
    List<int> signedBytes = bytes.map((byte) => byte > 128 ? byte - 256 : byte).toList();
    return signedBytes;
  }

  static int hexFromDigit(String c) {
    if (c == '0' ||
        c == '1' ||
        c == '2' ||
        c == '3' ||
        c == '4' ||
        c == '5' ||
        c == '6' ||
        c == '7' ||
        c == '8' ||
        c == '9') {
      return c.codeUnitAt(0) - 48;
    } else if (c == 'A' ||
        c == 'B' ||
        c == 'C' ||
        c == 'D' ||
        c == 'E' ||
        c == 'F') {
      return (c.codeUnitAt(0) - 65) + 10;
    } else if (c == 'a' ||
        c == 'b' ||
        c == 'c' ||
        c == 'd' ||
        c == 'e' ||
        c == 'f') {
      return (c.codeUnitAt(0) - 97) + 10;
    } else {
      throw FormatException("invalid hex digit '$c'");
    }
  }
}



class EncrptionClass {

 static  String getEncryptedString(String instr) {
     String encKey = "5de5a021833beb75551f29712d9ba6b2";
     try {
       var keyBytes = HexfromString(encKey);
       final skeySpec = PaddedBlockCipherParameters(
         KeyParameter(Uint8List.fromList(keyBytes)),
         null,
       );

       final cipher = PaddedBlockCipherImpl(
         PKCS7Padding(),
         ECBBlockCipher(AESFastEngine()),
       );

       cipher.init(true, skeySpec);

       if (instr != null && instr.isNotEmpty) {
         final plaintext = utf8.encode(instr);
         final encryptedBytes = cipher.process(Uint8List.fromList(plaintext));
         return hextoString(encryptedBytes);
       } else {
         return '';
       }
     } catch (e) {
       print(e);
       return '';
     }
   }


 static List<int> HexfromString(String hexString) {
   final i = hexString.length;
   Uint8List abyte0 = Uint8List((i + 1) ~/ 2);

   var j = 0;
   var k = 0;
   if (i % 2 == 1) {
     abyte0[k++] = hexFromDigit(hexString[j++]);
   }
   while (j < i) {
     abyte0[k++] =
     (hexFromDigit(hexString[j++]) << 4 | hexFromDigit(hexString[j++]));
   }
   print("+++++++++++++");
   print(abyte0);
   Uint8List bytes = Uint8List.fromList(abyte0);
   List<int> signedBytes = bytes.map((byte) => byte > 127 ? byte - 256 : byte).toList();
   return signedBytes;
  }
//[93, -27, -96, 33, -125, 59, -21, 117, 85, 31, 41, 113, 45, -101,-90,-78]
 static int hexFromDigit(String c) {
   if (c == '0' || c == '1' || c == '2' || c == '3' || c == '4' || c == '5' || c == '6' || c == '7' || c == '8' || c == '9') {
     return c.codeUnitAt(0) - 48;
   } else if (c == 'A' || c == 'B' || c == 'C' || c == 'D' || c == 'E' || c == 'F') {
     return (c.codeUnitAt(0) - 65) + 10;
   } else if (c == 'a' || c == 'b' || c == 'c' || c == 'd' || c == 'e' || c == 'f') {
     return (c.codeUnitAt(0) - 97) + 10;
   } else {
     throw FormatException("invalid hex digit '$c'");
   }
 }


static String hextoString(List<int> abyte0) {
   return hextoStringRange(abyte0, 0, abyte0.length);
 }

 static String hextoStringRange(List<int> abyte0, int i, int j) {
   final ac = List<String>.filled(j * 2, '');
   int k = 0;
   for (int l = i; l < i + j; l++) {
     int byte0 = abyte0[l];
     ac[k++] = hexDigits[(byte0 >>> 4) & 0xF];
     ac[k++] = hexDigits[byte0 & 0xF];
   }
   return ac.join();
 }

 static List<String> hexDigits = [
   '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
   'A', 'B', 'C', 'D', 'E', 'F'
 ];

}
