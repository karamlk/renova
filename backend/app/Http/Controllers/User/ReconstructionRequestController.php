<?php

namespace App\Http\Controllers\User;

use App\Http\Controllers\Controller;
use App\Http\Requests\ReconstructionRequest\StoreReconstructionRequest;
use App\Http\Requests\ReconstructionRequest\UpdateReconstructionRequest;
use App\Models\ReconstructionRequest;
use App\Services\User\ReconstructionRequestService;
use Illuminate\Http\Request;

class ReconstructionRequestController extends Controller
{
    public function __construct(
        protected ReconstructionRequestService $requestService
    ) {}

    public function store(
        StoreReconstructionRequest $request
    ) {

        $reconstructionRequest =
            $this->requestService->store($request);

        return response()->json([

            'message' => 'تم إنشاء الطلب بنجاح',

            'data' => $reconstructionRequest

        ], 201);
    }

//    public function index()
//    {
//        return response()->json([
//
//            'data' => $this->requestService->index()
//
//        ]);
    //}



    public function index(Request $request)
    {
        // 1. نظف قيم الفلاتر وتأكد إنها مو فاضية
        $location = $request->input('location');
        $type = $request->input('type');

        // 2. ابدأ الاستعلام الأساسي
        $query = ReconstructionRequest::with([
            'user.profile',
            'images'
        ]);

        // 3. فلتر حسب المنطقة (إذا أرسلها المستخدم)
        if (!empty($location)) {
            $query->where('location', $location);
        }

        // 4. فلتر حسب النوع (إذا أرسلها المستخدم)
        if (!empty($type)) {
            $query->where('type', $type);
        }

        // 5. جلب البيانات النهائية بعد الفلترة
        $requests = $query->latest()->get();

        return response()->json([
            'debug_filters' => [ // سطر للتأكد من القيم المرسلة (احذفه بعد التجربة)
                'received_location' => $location,
                'received_type' => $type
            ],
            'data' => $requests
        ]);
    }


    public function show($id)
    {
        return response()->json([

            'data' => $this->requestService->show($id)

        ]);
    }

    public function update(
        UpdateReconstructionRequest $request,
        $id
    ) {

        $reconstructionRequest =
            $this->requestService->update(
                $request,
                $id
            );

        return response()->json([

            'message' => 'تم تعديل الطلب',

            'data' => $reconstructionRequest

        ]);
    }

    public function destroy($id)
    {
        $this->requestService->destroy($id);

        return response()->json([

            'message' => 'تم حذف الطلب'

        ]);
    }
}
