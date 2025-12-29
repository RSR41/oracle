package com.rsr41.oracle.ui.screens.face

import android.net.Uri
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import coil.compose.rememberAsyncImagePainter
import com.rsr41.oracle.R
import com.rsr41.oracle.ui.components.*

@Composable
fun FaceReadingScreen(
    viewModel: FaceViewModel,
    onBack: () -> Unit
) {
    // Consent Check
    if (!viewModel.hasConsented) {
        FaceTermsDialog(
            onConfirm = { viewModel.agreeConsent() },
            onDismiss = onBack
        )
    }

    val galleryLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.GetContent()
    ) { uri: Uri? ->
        viewModel.onImageSelected(uri)
    }

    OracleScaffold(
        topBar = {
            OracleTopAppBar(
                title = stringResource(R.string.home_menu_face),
                onBack = onBack
            )
        }
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .verticalScroll(rememberScrollState())
                .padding(horizontal = 24.dp),
            verticalArrangement = Arrangement.spacedBy(24.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Spacer(modifier = Modifier.height(8.dp))
            
            // 1. 이미지 선택/프리뷰 영역
            OracleCard {
                Column(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    if (viewModel.selectedImageUri != null) {
                        // 선택된 이미지 프리뷰
                        Surface(
                            shape = RoundedCornerShape(16.dp),
                            modifier = Modifier
                                .fillMaxWidth()
                                .height(320.dp),
                            color = MaterialTheme.colorScheme.surfaceVariant
                        ) {
                            Box(contentAlignment = Alignment.Center) {
                                Image(
                                    painter = rememberAsyncImagePainter(viewModel.selectedImageUri),
                                    contentDescription = "Selected Face",
                                    modifier = Modifier.fillMaxSize(),
                                    contentScale = ContentScale.Crop
                                )
                                if (viewModel.isAnalyzing) {
                                    Surface(
                                        color = Color.Black.copy(alpha = 0.3f),
                                        modifier = Modifier.fillMaxSize()
                                    ) {
                                        Box(contentAlignment = Alignment.Center) {
                                            CircularProgressIndicator(color = Color.White)
                                        }
                                    }
                                }
                            }
                        }
                        
                        if (!viewModel.isAnalyzing && !viewModel.isAnalyzed) {
                             Spacer(modifier = Modifier.height(20.dp))
                             Text(
                                 text = stringResource(R.string.face_ready), 
                                 style = MaterialTheme.typography.titleMedium,
                                 color = MaterialTheme.colorScheme.primary,
                                 fontWeight = FontWeight.Bold
                             )
                        }
                    } else {
                        // 선택 전 placeholder
                         Column(
                            horizontalAlignment = Alignment.CenterHorizontally,
                            modifier = Modifier
                                .fillMaxWidth()
                                .padding(vertical = 40.dp)
                                .background(MaterialTheme.colorScheme.surface, RoundedCornerShape(16.dp))
                                .padding(32.dp)
                        ) {
                             Surface(
                                 shape = CircleShape,
                                 color = MaterialTheme.colorScheme.primary.copy(alpha = 0.05f),
                                 modifier = Modifier.size(80.dp)
                             ) {
                                 Box(contentAlignment = Alignment.Center) {
                                     Icon(Icons.Default.Face, null, modifier = Modifier.size(40.dp), tint = MaterialTheme.colorScheme.primary)
                                 }
                             }
                             Spacer(modifier = Modifier.height(24.dp))
                             Text(
                                 text = stringResource(R.string.face_upload_hint), 
                                 style = MaterialTheme.typography.bodyLarge,
                                 textAlign = TextAlign.Center,
                                 color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.6f)
                             )
                        }
                    }
                    
                    if (!viewModel.isAnalyzing && !viewModel.isAnalyzed) {
                        Spacer(modifier = Modifier.height(24.dp))
                        OracleSecondaryButton(
                            text = stringResource(R.string.face_gallery),
                            onClick = { galleryLauncher.launch("image/*") },
                            modifier = Modifier.fillMaxWidth()
                        )
                        Spacer(modifier = Modifier.height(16.dp))
                        Row(verticalAlignment = Alignment.CenterVertically) {
                             Icon(Icons.Default.Info, null, modifier = Modifier.size(14.dp), tint = MaterialTheme.colorScheme.secondary)
                             Spacer(modifier = Modifier.width(6.dp))
                             Text(
                                 text = stringResource(R.string.face_guide_photo), 
                                 style = MaterialTheme.typography.labelSmall, 
                                 color = MaterialTheme.colorScheme.secondary
                             )
                        }
                    }
                }
            }

            // 2. 분석 버튼
             if (viewModel.selectedImageUri != null && !viewModel.isAnalyzed && !viewModel.isAnalyzing) {
                OracleButton(
                    text = stringResource(R.string.face_analyze_btn),
                    onClick = { viewModel.analyze() },
                    modifier = Modifier.fillMaxWidth()
                )
            }

            // 3. 분석 결과
            if (viewModel.isAnalyzed) {
                OracleCard(
                    backgroundColor = MaterialTheme.colorScheme.primary.copy(alpha = 0.05f)
                ) {
                    OracleSectionTitle(stringResource(R.string.common_result), color = MaterialTheme.colorScheme.primary)
                    Text(
                        text = viewModel.analysisResult,
                        style = MaterialTheme.typography.bodyLarge,
                        lineHeight = 26.sp
                    )
                    Spacer(modifier = Modifier.height(24.dp))
                    OracleSecondaryButton(
                        text = stringResource(R.string.face_retake),
                        onClick = { viewModel.reset() },
                        modifier = Modifier.fillMaxWidth()
                    )
                }
            }
            
            // 4. 보안 안내
            OracleCard(
                backgroundColor = MaterialTheme.colorScheme.secondary.copy(alpha = 0.05f)
            ) {
                Row(verticalAlignment = Alignment.Top) {
                    Icon(
                        Icons.Default.Security, 
                        null, 
                        tint = MaterialTheme.colorScheme.secondary,
                        modifier = Modifier.size(20.dp)
                    )
                    Spacer(modifier = Modifier.width(12.dp))
                    Text(
                        text = stringResource(R.string.face_security_full), 
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.7f),
                        lineHeight = 18.sp
                    )
                }
            }
            
            Spacer(modifier = Modifier.height(32.dp))
        }
    }
}

@Composable
fun FaceTermsDialog(
    onConfirm: () -> Unit,
    onDismiss: () -> Unit
) {
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { 
            Text(
                stringResource(R.string.face_terms_title), 
                style = MaterialTheme.typography.titleLarge,
                fontWeight = FontWeight.Bold
            ) 
        },
        text = {
            Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                Text(
                    stringResource(R.string.face_terms_intro),
                    style = MaterialTheme.typography.bodyMedium
                )
                Surface(
                    color = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.5f),
                    shape = RoundedCornerShape(12.dp)
                ) {
                    Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
                        TermsBulletPoint(stringResource(R.string.face_terms_bullet_1))
                        TermsBulletPoint(stringResource(R.string.face_terms_bullet_2))
                        TermsBulletPoint(stringResource(R.string.face_terms_bullet_3))
                    }
                }
                Text(stringResource(R.string.face_terms_question), style = MaterialTheme.typography.bodySmall, fontWeight = FontWeight.Bold)
            }
        },
        confirmButton = {
            OracleButton(
                text = stringResource(R.string.face_terms_agree),
                onClick = onConfirm
            )
        },
        dismissButton = {
            TextButton(onClick = onDismiss) {
                Text(stringResource(R.string.common_cancel), color = MaterialTheme.colorScheme.outline)
            }
        },
        containerColor = MaterialTheme.colorScheme.surface,
        shape = RoundedCornerShape(24.dp)
    )
}

@Composable
private fun TermsBulletPoint(text: String) {
    Row(verticalAlignment = Alignment.Top) {
        Text("• ", style = MaterialTheme.typography.bodySmall, fontWeight = FontWeight.Bold)
        Text(text, style = MaterialTheme.typography.bodySmall)
    }
}
