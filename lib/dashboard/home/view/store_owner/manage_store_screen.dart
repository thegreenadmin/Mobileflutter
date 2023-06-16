import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/search_store_owner_controller.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/manage_product_screen.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/worker_list_screen.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/role_and_permission_screen.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/edit_store_detail_screen.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/shared_prefrences.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class ManageStoreScreen extends StatefulWidget {
  const ManageStoreScreen({super.key});

  @override
  State<ManageStoreScreen> createState() => _ManageStoreScreenState();
}

class _ManageStoreScreenState extends State<ManageStoreScreen> {
  final OwnerStoresController ownerStoresController =
      Get.put(OwnerStoresController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            height5SizedBox,
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                // SharedPreferenceStorage.setData("context", context);
                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (_) => const EditStoreDetailScreen(),
                // ));
                Get.to(const EditStoreDetailScreen(),id:int.parse(SharedPreferenceStorage.getData("pageId").toString() ));
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: const BoxDecoration(
                    color: AppColors.greylight,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    )),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: AppColors.white, width: 1)),
                                child: const CircleAvatar(
                                  radius: 28.0,
                                  backgroundImage: AssetImage(
                                    ImageConstants.blackcircle,
                                  ),
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                              Image.asset(
                                ImageConstants.editstore,
                                scale: 3,
                              ),
                            ],
                          ),
                          width10SizedBox,
                          Text(
                            StringConstants.editStoreDetailsText,
                            style: const TextStyle(
                                fontSize: 16.0,
                                color: AppColors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: AppColors.blacklight,
                        size: 24.0,
                      ),
                    ],
                  ),
                ]),
              ),
            ),
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                Get.parameters["storeId"] = ownerStoresController.storeId.value;
                Get.parameters["productId"] ="";
                Get.parameters["storeName"] =
                    ownerStoresController.storeName.value;
                Get.parameters["storeLocation"] =
                    ownerStoresController.storeLocation.value;
                // SharedPreferenceStorage.setData("context", context);
                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (_) => const MangeProductScreen(),
                // ));
                Get.to(const MangeProductScreen(),
                    id:int.parse(SharedPreferenceStorage.getData("pageId").toString() ),
                    arguments: {
                  "storeId": ownerStoresController.storeId.value,
                  "storeName": ownerStoresController.storeName.value,
                  "storeLocation": ownerStoresController.storeLocation.value,
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: const BoxDecoration(
                    color: AppColors.greylight,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    )),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: AppColors.white, width: 1)),
                                child: const CircleAvatar(
                                  radius: 28.0,
                                  backgroundImage: AssetImage(
                                    ImageConstants.blackcircle,
                                  ),
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                              Image.asset(
                                ImageConstants.manageproduct,
                                scale: 3,
                              ),
                            ],
                          ),
                          width10SizedBox,
                          Text(
                            StringConstants.manageProductsText,
                            style: const TextStyle(
                                fontSize: 16.0,
                                color: AppColors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: AppColors.blacklight,
                        size: 24.0,
                      ),
                    ],
                  ),
                ]),
              ),
            ),
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                Get.parameters["storeId"] = ownerStoresController.storeId.value;
                Get.parameters["storeName"] =
                    ownerStoresController.storeName.value;
                // SharedPreferenceStorage.setData("context", context);
                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (_) => const RoleAndPermissionScreen(),
                // ));
                Get.to(const RoleAndPermissionScreen(),
                    id:int.parse(SharedPreferenceStorage.getData("pageId").toString() ),
                    arguments: {
                  "storeId": ownerStoresController.storeId.value,
                  "storeName": ownerStoresController.storeName.value,
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: const BoxDecoration(
                    color: AppColors.greylight,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    )),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: AppColors.white, width: 1)),
                                child: const CircleAvatar(
                                  radius: 28.0,
                                  backgroundImage: AssetImage(
                                    ImageConstants.blackcircle,
                                  ),
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                              Image.asset(
                                ImageConstants.role,
                                scale: 3,
                              ),
                            ],
                          ),
                          width10SizedBox,
                          Text(
                            StringConstants.rolesAndPermissionText,
                            style: const TextStyle(
                                fontSize: 16.0,
                                color: AppColors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: AppColors.blacklight,
                        size: 24.0,
                      ),
                    ],
                  ),
                ]),
              ),
            ),
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                // SharedPreferenceStorage.setData("context", context);
                Get.parameters["storeId"] = ownerStoresController.storeId.value;
                Get.parameters["storeName"] =
                    ownerStoresController.storeName.value;

                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (_) => const WorkerListScreen(),
                // ));
                Get.to(const WorkerListScreen(),
                    id:int.parse(SharedPreferenceStorage.getData("pageId").toString() ),
                    arguments: {
                  "storeId": ownerStoresController.storeId.value,
                  "storeName": ownerStoresController.storeName.value,
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: const BoxDecoration(
                    color: AppColors.greylight,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    )),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: AppColors.white, width: 1)),
                                child: const CircleAvatar(
                                  radius: 28.0,
                                  backgroundImage: AssetImage(
                                    ImageConstants.blackcircle,
                                  ),
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                              Image.asset(
                                ImageConstants.worker,
                                scale: 3,
                              ),
                            ],
                          ),
                          width10SizedBox,
                          Text(
                            StringConstants.manageWorkersText,
                            style: const TextStyle(
                                fontSize: 16.0,
                                color: AppColors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: AppColors.blacklight,
                        size: 24.0,
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
