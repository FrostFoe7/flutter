import 'package:flutter/material.dart';
import 'package:threads/gen/assets.gen.dart';
import 'package:threads/ui/utils/utils.dart';
import 'package:timelines/timelines.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:threads/core/models/helper_model.dart';

// ignore: must_be_immutable
class FeedWidget extends StatelessWidget {
  FeedModel data;
  FeedWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return FixedTimeline.tileBuilder(
      theme: TimelineThemeData(
        nodePosition: 0,
        indicatorPosition: 0,
      ),
      builder: TimelineTileBuilder.connected(
        connectionDirection: ConnectionDirection.before,
        itemCount: 2,
        contentsBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: index == 0
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                data.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              4.width,
                              if (data.isVerified)
                                Assets.icons.verified.image(height: 16)
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                data.timeAgo,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppsTheme.color.grey,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              4.width,
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    builder: (context) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            _buildMenuOption(
                                                context, 'Report',
                                                isDestructive: true),
                                            const Divider(thickness: 0.5),
                                            _buildMenuOption(
                                                context, 'Not interested'),
                                            const Divider(thickness: 0.5),
                                            _buildMenuOption(
                                                context, 'Go to post'),
                                            const Divider(thickness: 0.5),
                                            _buildMenuOption(
                                                context, 'Share to...'),
                                            const Divider(thickness: 0.5),
                                            _buildMenuOption(
                                                context, 'Copy link'),
                                            const Divider(thickness: 0.5),
                                            _buildMenuOption(context, 'Embed'),
                                            const Divider(thickness: 0.5),
                                            _buildMenuOption(context,
                                                'About this account'),
                                            const Divider(thickness: 0.5),
                                            _buildMenuOption(context, 'Cancel',
                                                isCancel: true),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Assets.icons.threeDots.image(width: 30),
                              )
                            ],
                          )
                        ],
                      ),
                      5.height,
                      if (data.contentText != null)
                        Text(
                          data.contentText!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      if (data.contentPhoto != null) 8.height,
                      if (data.contentPhoto != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(data.contentPhoto!),
                        ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          children: [
                            Assets.icons.heart.image(height: 24),
                            12.width,
                            Assets.icons.message.image(height: 24),
                            12.width,
                            Assets.icons.repost.image(height: 24),
                            12.width,
                            Assets.icons.send.image(height: 24),
                          ],
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      if (data.replies != null)
                        Text(
                          '${data.replies} replies',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppsTheme.color.grey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      if (data.replies != null && data.likes != null)
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          width: 5.0,
                          height: 5.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppsTheme.color.grey,
                          ),
                        ),
                      if (data.likes != null)
                        Text(
                          '${data.likes} likes',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppsTheme.color.grey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                    ],
                  ),
          );
        },
        indicatorBuilder: (_, index) {
          if (index == 0) {
            return Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                child: CircleAvatar(
                  radius: 25.0,
                  backgroundColor: Colors.white,
                  child: !data.isFollow
                      ? CircleAvatar(
                          radius: 25.0,
                          backgroundImage: AssetImage(data.profile),
                          child: const Align(
                            alignment: Alignment.bottomRight,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 10.0,
                              child: CircleAvatar(
                                backgroundColor: Colors.black,
                                radius: 8,
                                child: Icon(
                                  Icons.add,
                                  size: 15.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                      : CircleAvatar(
                          radius: 25.0,
                          backgroundImage: AssetImage(data.profile),
                        ),
                ),
              ),
            );
          } else {
            return data.userLikes != null
                ? RowSuper(
                    fitHorizontally: true,
                    innerDistance: data.userLikes!.length > 1 ? -10.0 : 0,
                    alignment: Alignment.centerLeft,
                    children: List.generate(data.userLikes!.length, (index) {
                      return Container(
                        height: 28,
                        width: 28,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(50),
                          ),
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(data.userLikes![index].photo),
                        ),
                      );
                    }),
                  )
                : Container();
          }
        },
        connectorBuilder: (_, index, ___) => SolidLineConnector(
          thickness: 2.5,
          indent: 6,
          color: AppsTheme.color.neutral.shade400,
        ),
      ),
    );
  }

  Widget _buildMenuOption(BuildContext context, String title,
      {bool isDestructive = false, bool isCancel = false}) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isCancel || isDestructive ? FontWeight.bold : FontWeight.normal,
            color: isDestructive ? Colors.red : Colors.black,
          ),
        ),
      ),
    );
  }
}
