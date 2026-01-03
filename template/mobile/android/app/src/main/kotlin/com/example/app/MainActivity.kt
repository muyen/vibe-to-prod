package com.example.app

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET
import retrofit2.http.Query

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            MaterialTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    HelloScreen()
                }
            }
        }
    }
}

// API Interface
interface HelloApi {
    @GET("hello")
    suspend fun getHello(@Query("name") name: String = "Android"): HelloResponse
}

data class HelloResponse(val message: String)

// Simple API Client
object ApiClient {
    // TODO: Change to your backend URL
    private const val BASE_URL = "http://10.0.2.2:8080/api/v1/"

    val api: HelloApi by lazy {
        Retrofit.Builder()
            .baseUrl(BASE_URL)
            .addConverterFactory(GsonConverterFactory.create())
            .build()
            .create(HelloApi::class.java)
    }
}

@Composable
fun HelloScreen() {
    var message by remember { mutableStateOf("Tap to fetch") }
    var isLoading by remember { mutableStateOf(false) }
    var error by remember { mutableStateOf<String?>(null) }
    val scope = rememberCoroutineScope()

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(24.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Text(
            text = "Vibe to Prod",
            style = MaterialTheme.typography.headlineLarge
        )

        Text(
            text = "Android + Go Backend",
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )

        Spacer(modifier = Modifier.height(48.dp))

        when {
            isLoading -> CircularProgressIndicator()
            error != null -> {
                Text(
                    text = error ?: "",
                    color = MaterialTheme.colorScheme.error
                )
            }
            else -> {
                Card(
                    modifier = Modifier.padding(16.dp)
                ) {
                    Text(
                        text = message,
                        modifier = Modifier.padding(16.dp),
                        style = MaterialTheme.typography.titleMedium
                    )
                }
            }
        }

        Spacer(modifier = Modifier.height(48.dp))

        Button(
            onClick = {
                scope.launch {
                    isLoading = true
                    error = null
                    try {
                        val response = withContext(Dispatchers.IO) {
                            ApiClient.api.getHello()
                        }
                        message = response.message
                    } catch (e: Exception) {
                        error = "Error: ${e.message}"
                    } finally {
                        isLoading = false
                    }
                }
            },
            enabled = !isLoading
        ) {
            Text("Fetch from API")
        }
    }
}
