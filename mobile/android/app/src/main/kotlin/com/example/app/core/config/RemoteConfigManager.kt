package com.example.app.core.config

import android.util.Log
import com.google.firebase.Firebase
import com.google.firebase.remoteconfig.FirebaseRemoteConfig
import com.google.firebase.remoteconfig.remoteConfig
import com.google.firebase.remoteconfig.remoteConfigSettings
import com.example.app.BuildConfig

/**
 * Manages Firebase Remote Config feature flags.
 *
 * Used to control feature availability without app updates.
 * Flags are disabled by default and can be enabled via Firebase Console.
 *
 * Usage:
 * ```kotlin
 * val manager = RemoteConfigManager()
 * if (manager.isNewFeatureEnabled) {
 *     // Show new feature
 * }
 * ```
 */
class RemoteConfigManager {
    private val remoteConfig: FirebaseRemoteConfig = Firebase.remoteConfig

    init {
        val configSettings = remoteConfigSettings {
            // More frequent fetches in debug for testing
            minimumFetchIntervalInSeconds = if (BuildConfig.DEBUG) 60 else 3600
        }
        remoteConfig.setConfigSettingsAsync(configSettings)
        remoteConfig.setDefaultsAsync(DEFAULTS)

        // Fetch and activate on init
        remoteConfig.fetchAndActivate().addOnCompleteListener { task ->
            if (task.isSuccessful) {
                Log.d(TAG, "Remote Config fetched and activated")
            } else {
                Log.w(TAG, "Remote Config fetch failed, using defaults")
            }
        }
    }

    /**
     * Whether new feature is enabled.
     * Default: false (disabled, can be enabled via Firebase Console)
     */
    val isNewFeatureEnabled: Boolean
        get() = remoteConfig.getBoolean(KEY_NEW_FEATURE_ENABLED)

    /**
     * Whether maintenance mode is enabled.
     * Default: false (app functions normally)
     */
    val isMaintenanceMode: Boolean
        get() = remoteConfig.getBoolean(KEY_MAINTENANCE_MODE)

    /**
     * Get a string value from Remote Config
     */
    fun getString(key: String): String = remoteConfig.getString(key)

    /**
     * Get a long value from Remote Config
     */
    fun getLong(key: String): Long = remoteConfig.getLong(key)

    /**
     * Get a double value from Remote Config
     */
    fun getDouble(key: String): Double = remoteConfig.getDouble(key)

    /**
     * Get a boolean value from Remote Config
     */
    fun getBoolean(key: String): Boolean = remoteConfig.getBoolean(key)

    companion object {
        private const val TAG = "RemoteConfigManager"

        // Feature flag keys
        const val KEY_NEW_FEATURE_ENABLED = "new_feature_enabled"
        const val KEY_MAINTENANCE_MODE = "maintenance_mode"

        // Default values - features disabled by default for safety
        private val DEFAULTS = mapOf(
            KEY_NEW_FEATURE_ENABLED to false,
            KEY_MAINTENANCE_MODE to false
        )
    }
}
