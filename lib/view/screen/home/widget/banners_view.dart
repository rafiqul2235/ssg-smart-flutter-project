import 'package:carousel_slider/carousel_slider.dart';
import 'package:ssg_smart2/utill/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:ssg_smart2/provider/banner_provider.dart';
import 'package:ssg_smart2/utill/color_resources.dart';
import 'package:ssg_smart2/utill/images.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class BannersView extends StatelessWidget {

  Future<void> _loadData(BuildContext context, bool reload) async {
    await Provider.of<BannerProvider>(context, listen: false).getBannerList(reload, context);
  }

  _clickBannerRedirect(BuildContext context, int id, String slug,  String type){
      /*if(Provider.of<BrandProvider>(context, listen: false).brandList[bIndex].name != null){
        Navigator.push(context, MaterialPageRoute(builder: (_) => BrandAndCategoryProductScreen(
          isBrand: true,
          id: id.toString(),
          name: '${Provider.of<BrandProvider>(context, listen: false).brandList[bIndex].name}',
        )));
      }*/
  }

  @override
  Widget build(BuildContext context) {

    _loadData(context, false);

    return Column(
      children: [
        Consumer<BannerProvider>(
          builder: (context, bannerProvider, child) {
            double _width = MediaQuery.of(context).size.width;
            return Container(
              width: _width,
              height: _width * 0.35,
              child: bannerProvider.mainBannerList != null ? bannerProvider.mainBannerList.length != 0 ? Stack(
                fit: StackFit.expand,
                children: [
                  CarouselSlider.builder(
                    options: CarouselOptions(
                      viewportFraction: .95,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      disableCenter: true,
                      onPageChanged: (index, reason) {
                        Provider.of<BannerProvider>(context, listen: false).setCurrentIndex(index);
                      },
                    ),
                    itemCount: bannerProvider.mainBannerList.length == 0 ? 1 : bannerProvider.mainBannerList.length,
                    itemBuilder: (context, index, _) {
                      return InkWell(
                        onTap: () {
                         /* Provider.of<BannerProvider>(context, listen: false).getProductDetails(context, bannerProvider.mainBannerList[index].resourceId.toString());
                          _clickBannerRedirect(context, bannerProvider.mainBannerList[index].resourceType =='product'? bannerProvider.mainBannerList[index].product.id : bannerProvider.mainBannerList[index].resourceId, bannerProvider.mainBannerList[index].resourceType =='product'? bannerProvider.mainBannerList[index].product.slug : '', bannerProvider.mainBannerList[index].resourceType);
                         */
                        },
                        child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: //Image.asset(bannerProvider.mainBannerList[index].url!, fit: BoxFit.cover)
                            FadeInImage.assetNetwork(
                              placeholder: Images.placeholder, fit: BoxFit.cover,
                              image: '${AppConstants.BASE_URL}${bannerProvider.mainBannerList[index].url}',
                              imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  Positioned(
                    bottom: 5,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: bannerProvider.mainBannerList.map((banner) {
                        int index = bannerProvider.mainBannerList.indexOf(banner);
                        return TabPageSelectorIndicator(
                          backgroundColor: index == bannerProvider.currentIndex ? Theme.of(context).primaryColor : Colors.grey,
                          borderColor: index == bannerProvider.currentIndex ? Theme.of(context).primaryColor : Colors.grey,
                          size: 10,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ) : Center(child: Text('No banner available')) : Shimmer.fromColors(
                baseColor: Colors.grey,
                highlightColor: Colors.grey,
                enabled: bannerProvider.mainBannerList == null,
                child: Container(margin: EdgeInsets.symmetric(horizontal: 10), decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ColorResources.WHITE,
                )),
              ),
            );
          },
        ),

        SizedBox(height: 5),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9.0),
          child: Consumer<BannerProvider>(
            builder: (context, footerBannerProvider, child) {

              return footerBannerProvider.footerBannerList!=null && footerBannerProvider.footerBannerList.length != 0 ? GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: (2/1),
                ),
                itemCount: footerBannerProvider.footerBannerList.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {

                  return InkWell(
                    onTap: () {
                     /* Provider.of<BannerProvider>(context, listen: false).getProductDetails(context, footerBannerProvider.mainBannerList[index].resourceId.toString());
                      _clickBannerRedirect(context, footerBannerProvider.mainBannerList[index].resourceType=='product'?footerBannerProvider.mainBannerList[index].product.id :footerBannerProvider.mainBannerList[index].resourceId,footerBannerProvider.mainBannerList[index].resourceType =='product'?footerBannerProvider.mainBannerList[index].product.slug:'', footerBannerProvider.mainBannerList[index].resourceType);
                   */
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          child: FadeInImage.assetNetwork(
                            placeholder: Images.placeholder, fit: BoxFit.cover,
                            image: footerBannerProvider.mainBannerList[index].url! /*'${Provider.of<SplashProvider>(context,listen: false).baseUrls.bannerImageUrl}'
                                '/${footerBannerProvider.footerBannerList[index].photo}'*/,
                            imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
                  );

                },
              ):Shimmer.fromColors(
                baseColor: Colors.grey,
                highlightColor: Colors.grey,
                enabled: footerBannerProvider.footerBannerList == null,
                child: Container(margin: const EdgeInsets.symmetric(horizontal:10), decoration: BoxDecoration (
                  borderRadius: BorderRadius.circular(10),
                  color: ColorResources.WHITE,
                )),
              );
            },
          ),
        )
      ],
    );
  }


}

