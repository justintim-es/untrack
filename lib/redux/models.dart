class Msg {
	String value;
	DateTime date;
	Msg({ required this.value, required this.date });
	Msg.fromJson(Map<String, dynamic> jsoschon): value = jsoschon['value'], date = DateTime.parse(jsoschon['date']);
	Msg copyWith({
		String? value,
		DateTime? date,
	}) {
		return Msg(
			value: value ?? this.value,
			date: date ?? this.date
		);
	}
}
class ChatMsg extends Msg {
	bool ours;
	ChatMsg(this.ours, String value, DateTime date): super(value: value, date: date);
	ChatMsg.fromJson(Map<String, dynamic> jsoschon): ours = jsoschon['ours'], super.fromJson(jsoschon);
}
class ShowMsg extends Msg {
	bool isMutual;
	String toFrom;
	String? encryptedId;
	ShowMsg(this.isMutual, this.toFrom, this.encryptedId, String value, DateTime date): super(value: value, date: date);
	ShowMsg.fromJson(Map<String, dynamic> jsoschon):
		encryptedId = jsoschon['encryptedId'],
		isMutual = jsoschon['isMutual'],
		toFrom = jsoschon['toFrom'], super.fromJson(jsoschon);
}
class OurMsg extends Msg {
	String encryptedId;
	String toFrom;
	OurMsg({ required this.encryptedId, required this.toFrom, required String value, required DateTime date }) : super(value: value, date: date);
	OurMsg.fromJson(Map<String, dynamic> jsoschon):
		toFrom = jsoschon['toFrom'],
		encryptedId = jsoschon['encryptedId'],
		super.fromJson(jsoschon);
}
class StreamMsg extends Msg {
	bool isFromMe;
	bool isToMe;
	bool isFromMutual;
	bool isToMutual;
	int msgId;
	String? from;
	String? fromEncryptedId;
	String? to;
	String? toEncryptedId;
	List<Like> likes;
	List<Comment> comments;
	StreamMsg({
		required this.isFromMe,
		required this.isToMe,
		required this.isFromMutual,
		required this.isToMutual,
		required this.msgId,
		this.from,
		this.fromEncryptedId,
		this.to,
		this.toEncryptedId,
		required this.likes,
		required this.comments,
		required String value,
		required DateTime date,
	}): super(value: value, date: date);
	StreamMsg.fromJson(Map<String, dynamic> jsoschon):
		isFromMe = jsoschon['isFromMe'],
		isToMe = jsoschon['isToMe'],
		isFromMutual = jsoschon['isFromMutual'],
		isToMutual = jsoschon['isToMutual'],
		msgId = jsoschon['msgId'],
		from = jsoschon['from'],
		fromEncryptedId = jsoschon['fromEncryptedId'],
		to = jsoschon['to'],
		toEncryptedId = jsoschon['toEncryptedId'],
		likes =  jsoschon['likes'] ?? [],
		comments = jsoschon['comments'] ?? [],
		super.fromJson(jsoschon);

	StreamMsg copyWith({
			bool? isFromMe,
			bool? isToMe,
			bool? isFromMutual,
			bool? isToMutual,
			int? msgId,
			String? from,
			String? fromEncryptedId,
			String? to,
			String? toEncryptedId,
			List<Like>? likes,
			List<Comment>? comments,
			String? value,
			DateTime? date
	}) {
		return StreamMsg(
			isFromMe: isFromMe ?? this.isFromMe,
			isToMe: isToMe ?? this.isToMe,
			isFromMutual: isFromMutual ?? this.isFromMutual,
			isToMutual: isToMutual ?? this.isToMutual,
			msgId: msgId ?? this.msgId,
			from: from ?? this.from,
			fromEncryptedId: fromEncryptedId ?? this.fromEncryptedId,
			to: to ?? this.to,
			toEncryptedId: toEncryptedId ?? this.toEncryptedId,
			likes: likes ?? this.likes,
			comments: comments ?? this.comments,
			value: value ?? this.value,
			date: date ?? this.date
		);
	}
}
class ProfileFollow {
	bool mutual;
	String nickname;
	String? encryptedId;
	ProfileFollow.fromJson(Map<String, dynamic> jsoschon):
		mutual = jsoschon['mutual'],
		nickname = jsoschon['nickname'],
		encryptedId = jsoschon['encryptedId'];
}
class Like {
	bool isOurs;
	bool isMutual;
	String? encryptedId;
	String nickname;
	DateTime date;
	Like(this.isOurs, this.isMutual, this.encryptedId, this.nickname, this.date);
	Like.fromJson(Map<String, dynamic> jsoschon):
		isOurs = jsoschon['isOurs'],
		isMutual = jsoschon['isMutual'],
		encryptedId = jsoschon['encryptedId'],
		nickname = jsoschon['nickname'],
		date = DateTime.parse(jsoschon['date']);
}
class Comment {
	String value;
	DateTime date;
	String encryptedId;
	Comment(this.value, this.date, this.encryptedId);
	Comment.fromJson(Map<String, dynamic> jsoschon):
		value = jsoschon['value'],
		date = DateTime.parse(jsoschon['date']),
		encryptedId = jsoschon['encryptedId'];
}
