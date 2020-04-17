import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ourESchool/core/services/Services.dart';

class StorageServices extends Services {
  StorageServices() {
    getFirebaseUser();
    getSchoolCode();
  }

  Future<String> setProfilePhoto(String filePath) async {
    if (firebaseUser == null) await getFirebaseUser();
    if (schoolCode == null) await getSchoolCode();
    // String schoolCode = await sharedPreferencesHelper.getSchoolCode();

    String _extension = p.extension(filePath);
    String fileName = firebaseUser.uid + _extension;
    final StorageUploadTask uploadTask = storageReference
        .child(schoolCode + '/' + "Profile" + '/' + fileName)
        .putFile(
          File(filePath),
          StorageMetadata(
            contentType: "image",
            customMetadata: {
              "uploadedBy": firebaseUser.uid,
            },
          ),
        );

    final StorageTaskSnapshot downloadUrl = await uploadTask.onComplete;
    final String profileUrl = await downloadUrl.ref.getDownloadURL();

    await sharedPreferencesHelper.setLoggedInUserPhotoUrl(profileUrl);

    return profileUrl;
  }

  Future<String> uploadAnnouncemantPhoto(
      String filePath, String fileName) async {
    if (schoolCode == null) await getSchoolCode();
    if (firebaseUser == null) await getFirebaseUser();

    final StorageUploadTask uploadTask = storageReference
        .child(schoolCode + "/" + "Posts" + '/' + fileName)
        .putFile(
          File(filePath),
          StorageMetadata(
            contentType: "image",
            customMetadata: {
              "uploadedBy": firebaseUser.uid,
            },
          ),
        );

    final StorageTaskSnapshot downloadUrl = await uploadTask.onComplete;
    final String postmageUrl = await downloadUrl.ref.getDownloadURL();

    return postmageUrl;
  }

  Future<String> uploadAssignment(String filePath, String fileName) async {
    if (schoolCode == null) await getSchoolCode();
    if (firebaseUser == null) await getFirebaseUser();

    String _extension = p.extension(filePath);
    String file = fileName + _extension;

    final StorageUploadTask uploadTask = storageReference
        .child(schoolCode + "/" + "Assignments" + '/' + file)
        .putFile(
          File(filePath),
          StorageMetadata(
            contentType: "PDF",
            customMetadata: {
              "uploadedBy": firebaseUser.uid,
            },
          ),
        );

    final StorageTaskSnapshot downloadUrl = await uploadTask.onComplete;
    final String postmageUrl = await downloadUrl.ref.getDownloadURL();

    return postmageUrl;
  }
}
