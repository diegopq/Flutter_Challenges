import 'package:flutter/material.dart';
import 'package:retos_flutter_fb/modules/bottom_nav_player/data/api.dart';

class CardsList extends StatelessWidget {
  const CardsList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: Api.songsList.length + 2,
        restorationId: 'e',
        itemBuilder: (_, i) {
          return i == 0
              ? _HorizontalList()
              : i == Api.songsList.length + 1
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height * .1,
                    )
                  : _TrackCard(
                      index: i,
                      song: Api.songsList[i - 1],
                    );
        },
      ),
    );
  }
}

//lista de artistas
class _HorizontalList extends StatelessWidget {
  const _HorizontalList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final size = mq.size;
    return Container(
      margin: EdgeInsets.only(
        top: mq.padding.top,
        bottom: size.height * .04,
      ),
      height: size.height * .3,
      child: ListView.builder(
        addAutomaticKeepAlives: true,
        padding: EdgeInsets.symmetric(horizontal: 10),
        scrollDirection: Axis.horizontal,
        itemCount: Api.listOfArtist.length,
        itemBuilder: (context, i) {
          return _ArtistCard(
            artist: Api.listOfArtist[i],
          );
        },
      ),
    );
  }
}

//card de artista
class _ArtistCard extends StatefulWidget {
  final Map<String, String> artist;
  const _ArtistCard({Key key, @required this.artist}) : super(key: key);

  @override
  __ArtistCardState createState() => __ArtistCardState();
}

class __ArtistCardState extends State<_ArtistCard>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      height: size.height * .3,
      width: size.width * .38,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: Container(
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  widget.artist['image'],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ),
          Flexible(
            child: Text(
              widget.artist['name'],
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

//card de cancion
class _TrackCard extends StatefulWidget {
  final int index;
  final Map<String, String> song;
  _TrackCard({Key key, this.index, this.song}) : super(key: key);

  @override
  __TrackCardState createState() => __TrackCardState();
}

class __TrackCardState extends State<_TrackCard>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.index == 1
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 26),
                child: Text(
                  'Recently played',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    // letterSpacing: 0.05,
                  ),
                ),
              ),
              _Card(
                song: widget.song,
              )
            ],
          )
        : _Card(
            song: widget.song,
          );
  }

  @override
  bool get wantKeepAlive => true;
}

class _Card extends StatelessWidget {
  final Map<String, String> song;
  const _Card({Key key, @required this.song}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * .44,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 26),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.asset(
              song['albumImage'],
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: size.height * 0.03,
            left: 0.0,
            right: 0.0,
            child: Container(
              child: Column(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    margin: const EdgeInsets.only(bottom: 15),
                    child: Center(
                      child: CircleAvatar(
                        backgroundImage: AssetImage(
                          song['artistImage'],
                        ),
                      ),
                    ),
                  ),
                  Text(
                    song['artistName'],
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                  Text(
                    song['songName'],
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
