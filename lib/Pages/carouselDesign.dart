import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/widgets.dart';

class SocialPictureGroup extends StatelessWidget {
  const SocialPictureGroup({
    super.key,
    required this.image,
    required this.title,
    required this.color,
    required this.onTap,
    this.width = 400,
  });

  final String image;
  final String title;
  final Color color;
  final Function onTap;
  final double width;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            onTap();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: width,
                // ignore: sort_child_properties_last
                child: Image.asset(
                  image,
                  width: 400,
                  height: 200,
                  fit: BoxFit.contain,
                ),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(22)),
                    color: Color(0xFFAACCCC)),
                clipBehavior: Clip.antiAlias,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                title,
                style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'English'),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          color: const Color(0xFFAACCCC),
          child: const LikeListTile(
            title: "Customer Most Choices",
            likes: "130",
            subtitle: "103 Reviews",
            color: Colors.white,
          ),
        )
      ],
    );
  }
}

class LikeListTile extends StatelessWidget {
  // ignore: use_super_parameters
  const LikeListTile(
      {Key? key,
      required this.title,
      required this.likes,
      required this.subtitle,
      this.color = Colors.white})
      : super(key: key);
  final String title;
  final String likes;
  final String subtitle;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      leading: Container(
        width: 50,
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/images/categoryImage1.png'),
              ),
            ),
          ),
        ),
      ),
      title: Text(title),
      subtitle: Row(
        children: [
          const Icon(Icons.favorite, color: Colors.orange, size: 15),
          const SizedBox(width: 2),
          Text(likes),
          Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(width: 4, height: 4),
              )),
          Text(subtitle)
        ],
      ),
      trailing: LikeButton(onPressed: () {}, color: Colors.orange),
    );
  }
}

class LikeButton extends StatefulWidget {
  // ignore: use_super_parameters
  const LikeButton(
      {Key? key, required this.onPressed, this.color = Colors.white})
      : super(key: key);
  final Function onPressed;
  final Color color;
  @override
  // ignore: library_private_types_in_public_api
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
        child: IconButton(
      icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border,
          color: widget.color),
      onPressed: () {
        setState(() {
          isLiked = !isLiked;
        });
        widget.onPressed();
      },
    ));
  }
}
