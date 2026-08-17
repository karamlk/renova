<?php

namespace App\Services\Contractor;

use App\Models\ContractorPost;
use App\Models\ContractorPostImage;
use App\Models\Project;

class ContractorPostService
{
    /**
     * المشاريع المكتملة الخاصة بالمتعهد
     * والتي لم يتم إنشاء منشور لها بعد
     */
    public function availableProjects()
    {
        return Project::with([
            'form.reconstructionRequest',

        ])
            ->where('contractor_id', auth()->id())

            ->whereDoesntHave('post')
            ->latest()
            ->get() ->map(function ($project) {
                return [
                    'id' => $project->id,
                    'status'=>$project->status,
                    'title' => $project->form->reconstructionRequest->title,
                ];
            });
    }


    /**
     * إنشاء منشور من مشروع مكتمل
     */
    public function store($request)
    {
        $project = Project::with([
            'form.reconstructionRequest',
            'form.materials',
            'engineer',
        ])
            ->where('id', $request->project_id)

            // حماية: المشروع لازم يكون للمتعهد الحالي
            ->where('contractor_id', auth()->id())

            // لازم يكون المشروع منجز
           // ->where('status', 'completed')

            ->firstOrFail();


        // المشروع ما لازم يكون إله منشور سابق
//        if ($project->post) {
//            throw new \Exception(
//                'تم إنشاء منشور لهذا المشروع مسبقاً'
//            );
//        }


        $post = ContractorPost::create([

            'project_id' => $project->id,

            'user_id' => auth()->id(),

            // اسم المشروع مأخوذ من طلب إعادة الإعمار
            'title' =>$request->title
               ,

            // الوصف الجديد الذي يدخله المتعهد
            'description' => $request->description,

            // بما أن المشروع مكتمل
            'status' =>$project->status,

            'progress' => $project->progress,
        ]);


        // الصور الجديدة الخاصة بالمنشور
        if ($request->hasFile('images')) {

            foreach ($request->file('images') as $image) {

                $path = $image->store(
                    'contractor-posts',
                    'public'
                );

                ContractorPostImage::create([

                    'contractor_post_id' =>
                        $post->id,

                    'image' => $path,
                ]);
            }
        }


        return $post->load([
            'images',
            'user.contractorProfile',
            'project.form.reconstructionRequest',
            'project.form.materials',
            'project.engineer',
        ]);
    }


    public function index()
    {
        return ContractorPost::with([
            'images',
            'user.contractorProfile',
            'project.form.reconstructionRequest',
            'project.engineer',
        ])
            ->where('user_id', auth()->id())
            ->withCount('likes')
            ->latest()
            ->get();
    }


    public function show($id)
    {
        return ContractorPost::with([
            'images',
            'user.contractorProfile',
            'project.form.reconstructionRequest',
            'project.form.materials',
            'project.engineer',
        ])
            ->where('user_id', auth()->id())
            ->withCount('likes')
            ->findOrFail($id);
    }

//    public function post ($id)
//    {
//        return ContractorPost::with([
//            'images',
//            'user.contractorProfile',
//            'project.form.reconstructionRequest',
//            'project.form.materials',
//            'project.engineer',
//        ])
//            ->where('user_id', auth()->id())
//            ->withCount('likes')
//            ->withExists(['likes as is_liked' => function ($query) {
//                $query->where('user_id', auth()->id());
//            }])
//            ->findOrFail($id);
//    }
    public function post($id)
    {
        $currentUserId = auth()->id();
        $post = ContractorPost::find($id);

        // 1. إذا كان المنشور غير موجود أصلاً في الداتابيز
        if (!$post) {
            return response()->json(['error' => 'المنشور غير موجود في قاعدة البيانات أساساً'], 404);
        }

        // 2. إذا كان المستخدم غير مسجل دخول (Token مفقود)
        if (!$currentUserId) {
            return response()->json(['error' => 'لم يتم التعرف على المستخدم، تأكد من إرسال الـ Token'], 401);
        }

        // 3. إذا كان المنشور موجود ولكن يخص مستخدماً آخر
//        if ($post->user_id !== $currentUserId) {
//            return response()->json([
//                'error' => 'المنشور عائد لمستخدم آخر',
//                'post_owner_id' => $post->user_id,
//                'your_user_id' => $currentUserId
//            ], 403);
//        }

        // الكود الطبيعي في حال تطابق البيانات
        return ContractorPost::with([
            'images',
            'user.contractorProfile',
            'project.form.reconstructionRequest',
            'project.form.materials',
            'project.engineer',
        ])
            ->withCount('likes')
            ->withExists(['likes as is_liked' => function ($query) use ($currentUserId) {
                $query->where('user_id', $currentUserId);
            }])
            ->find($id);
    }


    /**
     * كل بوستات متعهد معين
     */
    public function contractorPosts($contractorId)
    {
        return ContractorPost::with([
            'images',
            'user.contractorProfile',
            'project.form.reconstructionRequest',
            'project.engineer',
        ])
            ->where('user_id', $contractorId)
            ->withCount('likes')
            ->withExists(['likes as is_liked' => function ($query) {
                $query->where('user_id', auth()->id());
            }])
            ->latest()
            ->get();
    }


    public function update($request, $id)
    {
        $post = ContractorPost::findOrFail($id);

        // حماية: فقط صاحب البوست يستطيع تعديله
        if ($post->user_id !== auth()->id()) {
            throw new \Exception('غير مصرح لك');
        }

        // تعديل الوصف فقط إذا تم إرساله
        if ($request->filled('description')) {
            $post->update([
                'description' => $request->description,
            ]);
        }

        // إضافة صور جديدة بدون حذف الصور القديمة
        if ($request->hasFile('images')) {

            foreach ($request->file('images') as $image) {

                $path = $image->store(
                    'contractor-posts',
                    'public'
                );

                ContractorPostImage::create([
                    'contractor_post_id' => $post->id,
                    'image' => $path,
                ]);
            }
        }

        return $post->load([
            'images',
            'user.contractorProfile',
            'project.form.reconstructionRequest',
            'project.engineer',
        ]);
    }
    public function delete($id)
    {
        $post = ContractorPost::findOrFail($id);

        if ($post->user_id !== auth()->id()) {
            throw new \Exception(
                'غير مصرح لك'
            );
        }

        $post->delete();
    }

    public function allPosts()
    {
        return ContractorPost::with([
            'images',
            'user.contractorProfile',
            'project.form.reconstructionRequest',
            'project.engineer',

        ])
            ->withCount('likes')
            ->withExists(['likes as is_liked' => function ($query) {
                $query->where('user_id', auth()->id());
            }])
            ->latest()
            ->get();

    }
}
