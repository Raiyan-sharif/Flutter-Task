package com.example.gallery_app

import android.Manifest
import android.content.ContentUris
import android.content.Context
import android.content.pm.PackageManager
import android.database.Cursor
import android.net.Uri
import android.os.Bundle
import android.provider.MediaStore
import android.widget.Toast
import androidx.annotation.NonNull
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.galleryApp/albums"
    private val PHOTOS_CHANNEL = "com.example.galleryApp/photos"
    private val REQUEST_CODE_STORAGE_PERMISSION = 101

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Request permission to read external storage
        requestStoragePermission()
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getAlbums" -> {
                    val albums = getAlbums(this)
                    result.success(albums)
                }
                else -> result.notImplemented()
            }
        }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PHOTOS_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getPhotos" -> {
                    val albumId = call.argument<String>("albumId")
                    val photos = getPhotos(this, albumId)
                    result.success(photos)
                }
                else -> result.notImplemented()
            }
        }
    }
    override fun configureFlutterEngine() {
        super.configureFlutterEngine()
        MethodChannel(flutterEngine!!.dartExecutor, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getFilePath") {
                val uri = call.argument<String>("uri")
                if (uri != null) {
                    val filePath = getRealPathFromURI(uri)
                    result.success(filePath)
                } else {
                    result.error("UNAVAILABLE", "File path not available.", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getRealPathFromURI(contentUri: String): String? {
        val cursor: Cursor? = contentResolver.query(Uri.parse(contentUri), null, null, null, null)
        cursor?.moveToFirst()
        val columnIndex = cursor?.getColumnIndex(MediaStore.Images.Media.DATA)
        val filePath = columnIndex?.let { cursor.getString(it) }
        cursor?.close()
        return filePath
    }

    // Function to request storage permission
    private fun requestStoragePermission() {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            // Request permission if not already granted
            ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.READ_EXTERNAL_STORAGE), REQUEST_CODE_STORAGE_PERMISSION)
        } else {
            // Permission already granted, proceed with your functionality
            Toast.makeText(this, "Permission granted", Toast.LENGTH_SHORT).show()
        }
    }

    // Handle the result of the permission request
    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        if (requestCode == REQUEST_CODE_STORAGE_PERMISSION) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                // Permission granted, proceed with your functionality
                Toast.makeText(this, "Permission granted", Toast.LENGTH_SHORT).show()
            } else {
                // Permission denied, show a message to the user
                Toast.makeText(this, "Permission denied", Toast.LENGTH_SHORT).show()
            }
        }
    }

    private fun getAlbums(context: Context): List<Map<String, Any>> {
        val albums = mutableListOf<Map<String, Any>>()
        val uri: Uri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI
        val projection = arrayOf(
            MediaStore.Images.Media.BUCKET_ID,
            MediaStore.Images.Media.BUCKET_DISPLAY_NAME,
            MediaStore.Images.Media._ID
        )
        val sortOrder = "${MediaStore.Images.Media.DATE_TAKEN} DESC"

        val cursor: Cursor? = context.contentResolver.query(uri, projection, null, null, sortOrder)
        cursor?.use {
            val bucketIdColumn = it.getColumnIndexOrThrow(MediaStore.Images.Media.BUCKET_ID)
            val bucketNameColumn = it.getColumnIndexOrThrow(MediaStore.Images.Media.BUCKET_DISPLAY_NAME)
            val idColumn = it.getColumnIndexOrThrow(MediaStore.Images.Media._ID)

            while (it.moveToNext()) {
                val bucketId = it.getString(bucketIdColumn)
                val bucketName = it.getString(bucketNameColumn)
                val id = it.getLong(idColumn)
                val thumbnailUri = ContentUris.withAppendedId(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, id).toString()

                val photoCount = getPhotoCount(context, bucketId)

                val album = mapOf(
                    "id" to bucketId,
                    "name" to bucketName,
                    "thumbnail" to thumbnailUri,
                    "photoCount" to photoCount
                )
                albums.add(album)
            }
        }
        return albums
    }

    private fun getPhotos(context: Context, albumId: String?): List<String> {
        val photos = mutableListOf<String>()
        val uri: Uri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI
        val projection = arrayOf(MediaStore.Images.Media._ID)
        val selection = "${MediaStore.Images.Media.BUCKET_ID} = ?"
        val selectionArgs = arrayOf(albumId)

        val cursor: Cursor? = context.contentResolver.query(uri, projection, selection, selectionArgs, null)
        cursor?.use {
            val idColumn = it.getColumnIndexOrThrow(MediaStore.Images.Media._ID)
            while (it.moveToNext()) {
                val id = it.getLong(idColumn)
                val photoUri = ContentUris.withAppendedId(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, id).toString()
                photos.add(photoUri)
            }
        }
        return photos
    }

    private fun getPhotoCount(context: Context, bucketId: String): Int {
        val uri: Uri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI
        val projection = arrayOf(MediaStore.Images.Media._ID)
        val selection = "${MediaStore.Images.Media.BUCKET_ID} = ?"
        val selectionArgs = arrayOf(bucketId)
        val cursor: Cursor? = context.contentResolver.query(uri, projection, selection, selectionArgs, null)
        val count = cursor?.count ?: 0
        cursor?.close()
        return count
    }
}
