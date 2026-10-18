import 'package:bahasa/features/decks/generate_deck/domain/entities/deck_generation_request.dart';
import 'package:bahasa/features/decks/import_deck/data/models/euy_card_model.dart';
import 'package:bahasa/features/decks/import_deck/data/models/euy_deck_model.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'ai_deck_json_parser.dart';

/// Data source executing online AI deck generation via Google Gemini API
/// with chunking progress updates and background retry resilience.
class GeminiDeckGeneratorDataSource {
  const GeminiDeckGeneratorDataSource();

  /// Generates a deck of 100 vocabulary cards using Gemini API in 4 chunks (25 cards each) with retries.
  Future<EuyDeckModel> generateDeck({
    required DeckGenerationRequest request,
    required String apiKey,
    void Function(int collected, int total)? onProgress,
  }) async {
    const totalTargetCards = 100;
    const totalChunks = 4;
    const cardsPerChunk = 25;

    onProgress?.call(0, totalTargetCards);

    final model = GenerativeModel(
      model: 'gemini-3.8-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        temperature: 0.7,
        maxOutputTokens: 8192,
      ),
    );

    String? generatedName;
    String? generatedExplanation;
    final allCards = <EuyCardModel>[];

    for (int chunkIndex = 0; chunkIndex < totalChunks; chunkIndex++) {
      final startNum = (chunkIndex * cardsPerChunk) + 1;
      final endNum = (chunkIndex + 1) * cardsPerChunk;

      int attempts = 0;
      bool chunkSuccess = false;

      while (attempts < 3 && !chunkSuccess) {
        attempts++;
        try {
          final prompt = _buildChunkPrompt(
            request: request,
            chunkIndex: chunkIndex,
            totalChunks: totalChunks,
            startNum: startNum,
            endNum: endNum,
            existingCards: allCards,
          );

          final response = await model.generateContent([Content.text(prompt)]);
          final text = response.text;

          if (text == null || text.trim().isEmpty) {
            throw const FormatException('Empty response received from Gemini API.');
          }

          final jsonMap = AiDeckJsonParser.cleanAndDecodeJson(text);

          if (chunkIndex == 0 && generatedName == null) {
            generatedName = jsonMap['name']?.toString();
            generatedExplanation = jsonMap['explanationRolePlay']?.toString();
          }

          final rawCards = jsonMap['cards'] as List<dynamic>? ?? [];
          final chunkCards = AiDeckJsonParser.parseCards(rawCards);

          if (chunkCards.isNotEmpty) {
            allCards.addAll(chunkCards);
            chunkSuccess = true;
            onProgress?.call(allCards.length, totalTargetCards);
          } else {
            throw FormatException('No cards parsed for chunk $chunkIndex.');
          }
        } catch (e) {
          if (attempts >= 3) {
            if (allCards.isNotEmpty) {
              chunkSuccess = true;
              break;
            }
            rethrow;
          }
          await Future<void>.delayed(const Duration(seconds: 1));
        }
      }
    }

    return AiDeckJsonParser.buildEuyDeck(
      request: request,
      generatedName: generatedName,
      generatedExplanation: generatedExplanation,
      cards: allCards,
    );
  }

  String _buildChunkPrompt({
    required DeckGenerationRequest request,
    required int chunkIndex,
    required int totalChunks,
    required int startNum,
    required int endNum,
    required List<EuyCardModel> existingCards,
  }) {
    final existingWords = existingCards
        .map((c) => c.defaultLanguage)
        .join(', ');
    final excludeNotice = existingWords.isNotEmpty
        ? 'Dilarang keras menggunakan kata-kata yang sudah ada ini: [$existingWords].'
        : '';

    return '''
Buatkan sebuah dek kartu kosakata (flashcard) bahasa asing dalam format JSON valid satu baris (minified JSON) tanpa tambahan teks pengantar, tanpa penjelasan penutup, dan tanpa blok kode markdown (```json), dengan struktur objek utama yang wajib dipatuhi secara persis: {"name": string, "explanationRolePlay": string, "cards": [{"defaultLanguage": string, "translation": string, "phoneticLang": string, "additionalContext": string}]}. 

Parameter dek yang diminta:
- Judul / Topik: "${request.name}"
- Bahasa Target (Kode/Nama): "${request.language}"
- Tingkat Kesulitan: "${request.difficulty}"
- Deskripsi / Fokus Khusus: "${request.description}"

Aturan pembuatan bagian ini (Bagian ${chunkIndex + 1} dari $totalChunks, nomor $startNum sampai $endNum):
(1) Properti "name" wajib diisi dengan judul dek dalam bahasa Inggris beserta tingkat kesulitannya, dan properti "explanationRolePlay" diisi dengan penjelasan singkat dalam bahasa Indonesia mengenai topik serta tingkat kesulitan yang diminta.
(2) Di dalam array "cards", WAJIB memuat tepat 25 kosakata atau frasa unik yang relevan untuk bagian ini, tanpa duplikasi kata atau pengulangan elemen. $excludeNotice
(3) Setiap objek di dalam array "cards" wajib memiliki properti "defaultLanguage" berisi kata atau frasa dalam bahasa Indonesia.
(4) Properti "translation" wajib berisi terjemahan kosakata ke bahasa target menggunakan aksara aslinya secara murni tanpa romanisasi, tanpa tanda kurung, dan tanpa teks tambahan.
(5) Properti "phoneticLang" wajib memuat transkripsi fonetik atau panduan cara baca dari kosakata bahasa target tersebut.
(6) Properti "additionalContext" wajib menggunakan bahasa Indonesia dengan pola format "Kelas Kata | Kategori Topik: Penjelasan" yang secara ketat mendefinisikan arti kosakata berdasarkan makna kontekstual dan fungsi penggunaannya yang sebenarnya di dunia nyata, bukan terjemahan harfiah atau literal.
''';
  }
}
