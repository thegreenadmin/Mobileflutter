import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/home/controller/search_store_owner_controller.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/edit_store_detail_screen.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/manage_product_screen.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/role_and_permission_screen.dart';
import 'package:thegreenmall/dashboard/home/view/store_owner/worker_list_screen.dart';
import 'package:thegreenmall/utils/utils.dart';

class ManageStoreScreen extends StatefulWidget {
  const ManageStoreScreen({super.key});

  @override
  State<ManageStoreScreen> createState() => _ManageStoreScreenState();
}

class _ManageStoreScreenState extends State<ManageStoreScreen> with GlobalVarMixin{
  final OwnerStoresController ownerStoresController =
  Get.isRegistered<OwnerStoresController>()
      ? Get.find()
      : Get.put(OwnerStoresController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildSingleChildScrollView(),
    );
  }

  SingleChildScrollView buildSingleChildScrollView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          height5SizedBox,
          Material(
            color: Colors.transparent, // keep design
            child: GestureDetector(

              behavior: HitTestBehavior.opaque,
             /* onTap: () async {
                final storeId = ownerStoresController.storeId.value;
                final hasEditPermission = permissionStoreList.any((element) =>
                (element.storeId == storeId && element.isStoreOwner == true) ||
                    (element.storeId == storeId.toString() &&
                        element.controllers?.any((c) =>
                        c.controllerKey == PermissionKey.editStore.statusName) == true));

                if ((hasStoreAccess.value && permissionStoreList.isEmpty) || hasEditPermission) {
                  Get.to(() => const EditStoreDetailScreen(), id: pageIdApp.value)
                      ?.then((_) => ownerStoresController.apiGetParticularStore());
                } else {
                  Utility.showAlertMessage(AlertStringConstants.notAuthorizedToStoreText);
                }
              },*/
              onTap: () async {
                if (ownerStoresController.storeId.value.isEmpty ||
                    permissionStoreList.isEmpty && !hasStoreAccess.value) {
                  Utility.showAlertMessage("Please wait, store data is loading...");
                  return;
                }

                final storeId = ownerStoresController.storeId.value;
                final hasEditPermission = permissionStoreList.any((element) =>
                (element.storeId == storeId && element.isStoreOwner == true) ||
                    (element.storeId == storeId.toString() &&
                        element.controllers?.any((c) =>
                        c.controllerKey == PermissionKey.editStore.statusName) == true));

                if ((hasStoreAccess.value && permissionStoreList.isEmpty) || hasEditPermission) {
                  Get.to(() => const EditStoreDetailScreen(), id: pageIdApp.value)
                      ?.then((_) => ownerStoresController.apiGetParticularStore());
                } else {
                  Utility.showAlertMessage(AlertStringConstants.notAuthorizedToStoreText);
                }
              },

              child: Container(
                width: double.infinity, //  ensures full width clickable
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: const BoxDecoration(
                    color: AppColors.greyLight,
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
                        color: AppColors.blackLight,
                        size: 24.0,
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          ),
          Material(
            color: Colors.transparent, // keep design
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                // Get.parameters["storeId"] = ownerStoresController.storeId.value;
                // Get.parameters["productId"] = "";
                // Get.parameters["storeName"] =
                //     ownerStoresController.storeName.value;
                // Get.parameters["storeLocation"] =
                //     ownerStoresController.storeLocation.value;
                Get.to(() =>  MangeProductScreen(
                    storeLocation:ownerStoresController.storeLocation.value,
                    storeName:ownerStoresController.storeName.value,
                    productId:"",
                    storeId:ownerStoresController.storeId.value
                ),
                    id: pageIdApp.value,
                );
              },
              child: Container(  width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: const BoxDecoration(
                    color: AppColors.greyLight,
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
                        color: AppColors.blackLight,
                        size: 24.0,
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          ),
          Material(
            color: Colors.transparent, // keep design
            child:GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                // Get.parameters["storeId"] = ownerStoresController.storeId.value;
                // Get.parameters["storeName"] =
                //     ownerStoresController.storeName.value;
                Get.to(() => RoleAndPermissionScreen(
                    storeId:ownerStoresController.storeId.value,
                    storeName:ownerStoresController.storeName.value
                ),
                    id: pageIdApp.value,
                   );
              },
              child: Container(  width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: const BoxDecoration(
                    color: AppColors.greyLight,
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
                        color: AppColors.blackLight,
                        size: 24.0,
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          ),
          Material(
            color: Colors.transparent, // keep design
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {

                // Get.parameters["storeId"] = ownerStoresController.storeId.value;
                // Get.parameters["storeName"] =
                //     ownerStoresController.storeName.value;


                hasStoreAccess.value && permissionStoreList.isEmpty ||
                        permissionStoreList.any((element) =>
                            element.storeId ==
                                    ownerStoresController.storeId.value &&
                                element.isStoreOwner == true ||
                            element.storeId ==
                                    ownerStoresController.storeId.value
                                        .toString() &&
                                element.controllers!.any((ele) =>
                                    ele.controllerKey ==
                                    PermissionKey.viewStoreUsers.statusName))
                    ? Get.to(() =>  WorkerListScreen(
                  storeId: ownerStoresController.storeId.value,
                  storeName: ownerStoresController.storeName.value,
                ),
                        id: pageIdApp.value,)
                    : Utility.showAlertMessage(
                        AlertStringConstants.notAuthorizedToStoreText);
              },
              child: Container(  width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: const BoxDecoration(
                    color: AppColors.greyLight,
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
                        color: AppColors.blackLight,
                        size: 24.0,
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
