import { NextRequest, NextResponse } from 'next/server';

/**
 * POST /api/v1/ppt/google/models/available
 * Fetches available Google Gemini models
 */
export async function POST(request: NextRequest) {
    try {
        const body = await request.json();
        const { api_key } = body;

        if (!api_key) {
            return NextResponse.json(
                { error: 'API key is required' },
                { status: 400 }
            );
        }

        // List of available Gemini models
        // In production, you might want to fetch this dynamically
        const models = [
            'models/gemini-2.0-flash-exp',
            'models/gemini-1.5-flash',
            'models/gemini-1.5-flash-8b',
            'models/gemini-1.5-pro',
            'models/gemini-pro',
        ];

        return NextResponse.json(models);
    } catch (error: any) {
        console.error('Error fetching Google models:', error);
        return NextResponse.json(
            { error: error.message || 'Failed to fetch models' },
            { status: 500 }
        );
    }
}
