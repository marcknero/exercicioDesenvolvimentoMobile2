import 'banco_localizacoes.dart';
import '../models/localizacao.dart';

class RepositorioLocalizacoes {
  Future<int> inserir(Localizacao localizacao) async {
    final db = await BancoLocalizacoes.instance.database;
    return await db.insert('localizacoes', localizacao.toMap());
  }

  Future<List<Localizacao>> consultarUltimas100() async {
    final db = await BancoLocalizacoes.instance.database;
    final result = await db.query(
      'localizacoes',
      orderBy: 'id DESC',
      limit: 100,
    );
    return result.map((map) => Localizacao.fromMap(map)).toList();
  }

  Future<void> limparHistorico() async {
    final db = await BancoLocalizacoes.instance.database;
    await db.delete('localizacoes');
  }
}