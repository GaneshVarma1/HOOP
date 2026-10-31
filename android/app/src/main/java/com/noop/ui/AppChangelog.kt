package com.noop.ui

import com.noop.R
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.HourglassEmpty
import androidx.compose.material.icons.outlined.Science
import androidx.compose.material.icons.outlined.Shield
import androidx.compose.material.icons.outlined.VerifiedUser
import androidx.compose.ui.graphics.vector.ImageVector

// MARK: - AppChangelog (ported byte-for-byte from Strand/System/AppChangelog.swift)
//
// Single source of truth for the in-app "What's New" sheet and the expectation-setting
// copy used in onboarding. Mirrored from the macOS `AppChangelog` enum so every surface
// — macOS and Android — tells the same HOOP baseline story.
//
// Icon mapping (SF Symbol → Material, all verified to resolve in material-icons-extended):
//   flask           → Icons.Outlined.Science        (independent / experimental)
//   checkmark.seal  → Icons.Outlined.VerifiedUser   (the supported path)
//   hourglass       → Icons.Outlined.HourglassEmpty (scores build over time)
//   lock.shield     → Icons.Outlined.Shield         (everything stays on-device)

object AppChangelog {

    /**
     * Bump this when you add a release below. The "What's New" sheet shows automatically when the
     * stored last-seen version is behind this. (Decoupled from the bundle version on purpose.)
     */
    const val CURRENT_VERSION = "12.0.0"

    data class Release(
        val version: String,
        val title: String,
        val date: String,
        val items: List<String>,
    )

    /** HOOP release notes begin with this app's baseline. */
    val releases: List<Release> = listOf(
        Release(
            version = "12.0.0",
            title = uiString(R.string.app_name),
            date = "October 2026",
            items = listOf(
                "HOOP has its own name, icon and blue-accented interface across iPhone, Mac and Android.",
                "When Bluetooth is off, HOOP explains how to turn it on and reconnect your strap.",
                "Your strap data and computed scores stay on your device.",
            ),
        ),
    )

    data class Expectation(
        val icon: ImageVector,
        val title: String,
        val body: String,
    )

    val expectations: List<Expectation> = listOf(
        Expectation(
            icon = Icons.Outlined.Science,
            title = uiString(R.string.l10n_app_changelog_independent_and_experimental_f9b65317),
            body = uiString(R.string.onboarding_expectation_independent_body),
        ),
        Expectation(
            icon = Icons.Outlined.VerifiedUser,
            title = uiString(R.string.l10n_app_changelog_whoop_4_0_is_the_supported_16893d9d),
            body = uiString(R.string.onboarding_expectation_whoop_support_body),
        ),
        Expectation(
            icon = Icons.Outlined.HourglassEmpty,
            title = uiString(R.string.l10n_app_changelog_your_scores_build_over_a_few_41388c54),
            body = uiString(R.string.onboarding_expectation_scores_body),
        ),
        Expectation(
            icon = Icons.Outlined.Shield,
            title = uiString(R.string.l10n_app_changelog_everything_stays_on_your_device_575125e9),
            body = uiString(R.string.onboarding_expectation_local_body),
        ),
    )
}
