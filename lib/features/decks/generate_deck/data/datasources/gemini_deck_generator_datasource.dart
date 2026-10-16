import 'package:bahasa/features/decks/generate_deck/domain/entities/deck_generation_request.dart';
import 'package:bahasa/features/decks/import_deck/data/models/euy_deck_model.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'ai_deck_json_parser.dart';

/// Data source executing online AI deck generation via Google Gemini API.
class GeminiDeckGeneratorDataSource {
  const GeminiDeckGeneratorDataSource();

  /// Generates a deck of vocabulary cards using Gemini 1.5 Flash.
  Future<EuyDeckModel> generateDeck({
    required DeckGenerationRequest request,
    required String apiKey,
  }) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        temperature: 0.7,
      ),
    );

    final prompt = _buildPrompt(request);
    final response = await model.generateContent([Content.text(prompt)]);

    final text = response.text;
    if (text == null || text.trim().isEmpty) {
      throw const FormatException('Empty response received from Gemini API.');
    }

    final jsonMap = AiDeckJsonParser.cleanAndDecodeJson(text);
    final rawCards = jsonMap['cards'] as List<dynamic>? ?? [];
    final cards = AiDeckJsonParser.parseCards(rawCards);

    return AiDeckJsonParser.buildEuyDeck(
      request: request,
      generatedName: jsonMap['name']?.toString(),
      generatedExplanation: jsonMap['explanationRolePlay']?.toString(),
      cards: cards,
    );
  }

  String _buildPrompt(DeckGenerationRequest request) {
    return '''
Buatkan sebuah dek kartu kosakata (flashcard) bahasa asing dalam format JSON valid satu baris (minified JSON) tanpa tambahan teks pengantar, tanpa penjelasan penutup, dan tanpa blok kode markdown (```json), dengan struktur objek utama yang wajib dipatuhi secara persis: {"name": string, "explanationRolePlay": string, "cards": [{"defaultLanguage": string, "translation": string, "phoneticLang": string, "additionalContext": string}]}. 

Parameter dek yang diminta:
- Judul / Topik: "${request.name}"
- Bahasa Target (Kode/Nama): "${request.language}"
- Tingkat Kesulitan: "${request.difficulty}"
- Deskripsi / Fokus Khusus: "${request.description}"

Ikuti aturan berikut:
(1) Properti "name" wajib diisi dengan judul dek dalam bahasa Inggris beserta tingkat kesulitannya, dan properti "explanationRolePlay" diisi dengan penjelasan singkat dalam bahasa Indonesia mengenai topik serta tingkat kesulitan yang diminta.
(2) Di dalam array "cards", buatkan kosakata atau frasa unik yang relevan dengan topik dan tingkat kesulitan tersebut tanpa duplikasi kata atau pengulangan elemen.
(3) Setiap objek di dalam array "cards" wajib memiliki properti "defaultLanguage" berisi kata atau frasa dalam bahasa Indonesia.
(4) Properti "translation" wajib berisi terjemahan kosakata ke bahasa target menggunakan aksara aslinya secara murni tanpa romanisasi, tanpa tanda kurung, dan tanpa teks tambahan.
(5) Properti "phoneticLang" wajib memuat transkripsi fonetik atau panduan cara baca dari kosakata bahasa target tersebut.
(6) Properti "additionalContext" wajib menggunakan bahasa Indonesia dengan pola format "Kelas Kata | Kategori Topik: Penjelasan" yang secara ketat mendefinisikan arti kosakata berdasarkan makna kontekstual dan fungsi penggunaannya yang sebenarnya di dunia nyata, bukan terjemahan harfiah atau literal.
''';
  }
}
