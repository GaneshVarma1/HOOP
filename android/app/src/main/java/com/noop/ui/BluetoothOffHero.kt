package com.noop.ui

import com.noop.R
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.animation.core.LinearEasing
import androidx.compose.animation.core.RepeatMode
import androidx.compose.animation.core.animateFloat
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.tween
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.BluetoothDisabled
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.semantics.clearAndSetSemantics
import androidx.compose.ui.unit.dp

/**
 * Whether the phone's Bluetooth radio is on, kept live: it re-reads the adapter on every
 * [BluetoothAdapter.ACTION_STATE_CHANGED] broadcast, so a card keyed on it appears and disappears
 * the moment the user flips Bluetooth, with no reconnect or recomposition trigger needed.
 */
@Composable
fun rememberBluetoothOn(): Boolean {
    val context = LocalContext.current
    val adapter = remember(context) {
        (context.getSystemService(Context.BLUETOOTH_SERVICE) as? BluetoothManager)?.adapter
    }
    var on by remember { mutableStateOf(adapter?.isEnabled == true) }
    DisposableEffect(context, adapter) {
        val receiver = object : BroadcastReceiver() {
            override fun onReceive(unused: Context?, intent: Intent?) {
                on = adapter?.isEnabled == true
            }
        }
        val registered = runCatching {
            context.registerReceiver(receiver, IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED))
        }.isSuccess
        on = adapter?.isEnabled == true
        onDispose { if (registered) runCatching { context.unregisterReceiver(receiver) } }
    }
    return on
}

/**
 * The Bluetooth-off card: a Bluetooth-off glyph with rings breathing out from it (held still under
 * Reduce Motion, Battery Saver and Quiet Motion), the three steps that fix it, and a one-tap
 * "Turn on Bluetooth" that raises the system enable dialog. Parity with the Apple
 * BluetoothOffNotice. Shows nothing while Bluetooth is on.
 */
@Composable
fun BluetoothOffHero(modifier: Modifier = Modifier) {
    val bluetoothOn = rememberBluetoothOn()
    if (bluetoothOn) return

    val enableLauncher = rememberLauncherForActivityResult(
        ActivityResultContracts.StartActivityForResult(),
    ) { /* rememberBluetoothOn picks up the change from the state broadcast */ }

    NoopCard(modifier = modifier, tint = Palette.accent) {
        Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(16.dp),
            ) {
                BluetoothOffSignal()
                Column(verticalArrangement = Arrangement.spacedBy(4.dp)) {
                    Text(uiString(R.string.l10n_bluetooth_off_hero_bluetooth_is_off_28f3a642), style = NoopType.title2, color = Palette.textPrimary)
                    Text(
                        uiString(R.string.l10n_bluetooth_off_hero_hoop_can_t_reach_your_band_a8f588ac),
                        style = NoopType.subhead,
                        color = Palette.textSecondary,
                    )
                }
            }
            Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
                FixStep(1, uiString(R.string.l10n_bluetooth_off_hero_tap_turn_on_bluetooth_below_or_2f9b1eee))
                FixStep(2, uiString(R.string.l10n_bluetooth_off_hero_allow_hoop_to_turn_it_on_78c64ccd))
                FixStep(3, uiString(R.string.l10n_bluetooth_off_hero_keep_your_band_nearby_hoop_reconnects_784985f2))
            }
            Button(
                onClick = {
                    runCatching { enableLauncher.launch(Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)) }
                },
                modifier = Modifier.fillMaxWidth().heightIn(min = 48.dp),
                colors = ButtonDefaults.buttonColors(
                    containerColor = Palette.accent,
                    contentColor = Palette.surfaceBase,
                ),
            ) { Text(uiString(R.string.l10n_bluetooth_off_hero_turn_on_bluetooth_9f48a309), style = NoopType.headline) }
        }
    }
}

/** Accent disc with a Bluetooth-off glyph and two rings breathing outward behind it. */
@Composable
private fun BluetoothOffSignal() {
    val still = rememberPoseStill()
    val ring = Palette.accent
    Box(
        modifier = Modifier.size(56.dp).clearAndSetSemantics {},
        contentAlignment = Alignment.Center,
    ) {
        if (!still) {
            val phase by rememberInfiniteTransition().animateFloat(
                initialValue = 0f,
                targetValue = 1f,
                animationSpec = infiniteRepeatable(
                    animation = tween(2_400, easing = LinearEasing),
                    repeatMode = RepeatMode.Restart,
                ),
            )
            Canvas(Modifier.size(56.dp)) {
                val base = size.minDimension / 2f
                // Two rings half a cycle apart, each growing to 1.55x and fading out.
                for (offset in floatArrayOf(0f, 0.5f)) {
                    val t = (phase + offset) % 1f
                    drawCircle(
                        color = ring.copy(alpha = 0.8f * (1f - t)),
                        radius = base * (1f + 0.55f * t),
                        style = Stroke(width = 1.5.dp.toPx()),
                    )
                }
            }
        }
        Box(
            modifier = Modifier.size(56.dp).background(Palette.accentMuted, CircleShape),
            contentAlignment = Alignment.Center,
        ) {
            Icon(Icons.Filled.BluetoothDisabled, contentDescription = null, tint = Palette.accent)
        }
    }
}

@Composable
private fun FixStep(number: Int, text: String) {
    Row(horizontalArrangement = Arrangement.spacedBy(10.dp), verticalAlignment = Alignment.Top) {
        Box(
            modifier = Modifier.size(22.dp).background(Palette.accentMuted, CircleShape).clearAndSetSemantics {},
            contentAlignment = Alignment.Center,
        ) {
            Text(number.toString(), style = NoopType.caption, color = Palette.accent)
        }
        Text(text, style = NoopType.subhead, color = Palette.textPrimary)
    }
}
